<template>
  <div class="address-edit">
    <van-nav-bar
      :title="isEdit ? '编辑地址' : '新增地址'"
      left-arrow
      @click-left="onClickLeft"
    />
    <van-address-edit
      :area-list="areaList"
      :address-info="addressInfo"
      show-delete
      show-set-default
      show-search-result
      :area-columns-placeholder="['请选择', '请选择', '请选择']"
      @save="onSave"
      @delete="onDelete"
    />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { areaList } from '@vant/area-data';
import request from '../../utils/request';
import { showToast } from 'vant';

const router = useRouter();
const route = useRoute();
const addressInfo = ref({});

const isEdit = computed(() => !!route.query.id);

onMounted(async () => {
  if (isEdit.value) {
    try {
      const res = await request.get(`/address/${route.query.id}`);
      // 转换后端数据格式适配组件
      // 后端: province, city, county, addressDetail
      // 组件需要匹配 areaCode 才能自动显示省市区，但这里简化处理，如果没有 areaCode，组件可能无法回显省市区选择器
      // 实际项目中需要后端存储 areaCode 或者前端根据名称反查
      addressInfo.value = {
          ...res,
          isDefault: res.isDefault,
          // 暂时无法完美回显省市区选择器，除非后端存了 code
          // 这里仅作演示，addressDetail 回显是没问题的
      };
    } catch (error) {
      console.error(error);
    }
  }
});

const onClickLeft = () => router.back();

const onSave = async (content) => {
  try {
    const data = {
      name: content.name,
      tel: content.tel,
      province: content.province,
      city: content.city,
      county: content.county,
      addressDetail: content.addressDetail,
      isDefault: content.isDefault,
      areaCode: content.areaCode
    };

    if (isEdit.value) {
      await request.put(`/address/${route.query.id}`, data);
      showToast('修改成功');
    } else {
      await request.post('/address', data);
      showToast('添加成功');
    }
    router.back();
  } catch (error) {
    console.error(error);
  }
};

const onDelete = async () => {
  if (isEdit.value) {
    try {
      await request.delete(`/address/${route.query.id}`);
      showToast('删除成功');
      router.back();
    } catch (error) {
      console.error(error);
    }
  }
};
</script>

<style lang="less" scoped>
.address-edit {
  min-height: 100vh;
  background-color: #f7f8fa;
}
</style>