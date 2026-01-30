<template>
  <div class="address-list">
    <van-nav-bar
      title="收货地址"
      left-arrow
      @click-left="onClickLeft"
    />
    <van-address-list
      v-model="chosenAddressId"
      :list="list"
      default-tag-text="默认"
      @add="onAdd"
      @edit="onEdit"
      @select="onSelect"
    />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import request from '../../utils/request';

const router = useRouter();
const chosenAddressId = ref('');
const list = ref([]);

const fetchList = async () => {
  try {
    const res = await request.get('/address');
    list.value = res;
    // 如果没有选中的，且有默认地址，则选中默认
    if (!chosenAddressId.value) {
      const defaultAddr = list.value.find(item => item.isDefault);
      if (defaultAddr) {
        chosenAddressId.value = defaultAddr.id;
      }
    }
  } catch (error) {
    console.error(error);
  }
};

onMounted(() => {
  fetchList();
});

const onClickLeft = () => router.back();
const onAdd = () => router.push('/address/edit');
const onEdit = (item) => router.push(`/address/edit?id=${item.id}`);
const onSelect = (item) => {
    // 选中地址后，如果是从订单确认页过来的，可以回传
    console.log('selected', item);
};
</script>

<style lang="less" scoped>
.address-list {
  min-height: 100vh;
  background-color: #f7f8fa;
}
</style>