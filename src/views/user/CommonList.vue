<template>
  <div class="common-list-page">
    <van-nav-bar 
      :title="title" 
      left-arrow 
      @click-left="onClickLeft" 
      fixed 
      placeholder
      :right-text="list.length > 0 ? (isEditMode ? '完成' : '管理') : ''"
      @click-right="toggleEditMode"
    />
    
    <van-pull-refresh v-model="refreshing" @refresh="onRefresh" :disabled="isEditMode">
      <van-list
        v-model:loading="loading"
        :finished="finished"
        finished-text="没有更多了"
        @load="onLoad"
      >
        <div v-if="list.length > 0" class="goods-list" :class="{ 'is-edit': isEditMode }">
             <van-checkbox-group v-model="checkedIds">
               <div class="goods-item-wrapper" v-for="item in list" :key="item.id">
                 <van-checkbox :name="item.id" v-if="isEditMode" class="item-checkbox" />
                 
                 <van-swipe-cell class="goods-swipe-cell" :disabled="isEditMode">
                   <div class="goods-item" @click="goDetail(item.id)">
                     <div class="goods-img">
                       <img :src="item.main_image" alt="">
                     </div>
                     <div class="goods-info">
                       <div class="goods-name">{{ item.name }}</div>
                       <div class="goods-price">
                         <span class="price-symbol">¥</span>
                         <span class="price-num">{{ item.price }}</span>
                         <span class="time-tip" v-if="isHistory">浏览于 {{ formatTime(item.updated_at) }}</span>
                       </div>
                     </div>
                   </div>
                   <template #right>
                     <van-button square text="删除" type="danger" class="delete-button" @click="onDeleteOne(item.id)" />
                   </template>
                 </van-swipe-cell>
               </div>
             </van-checkbox-group>
        </div>
        <van-empty v-else description="暂无相关记录" />
      </van-list>
    </van-pull-refresh>

    <!-- 底部操作栏 -->
    <van-submit-bar
      v-if="isEditMode"
      button-text="删除"
      @submit="onBatchDelete"
      class="edit-footer"
    >
      <van-checkbox v-model="checkedAll" @click="toggleAll">全选</van-checkbox>
    </van-submit-bar>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import request from '../../utils/request';
import { showToast, showDialog } from 'vant';
import 'vant/es/dialog/style';
import 'vant/es/toast/style';

const route = useRoute();
const router = useRouter();

const title = computed(() => route.meta.title || '列表');
const isHistory = computed(() => route.path.includes('history'));

const list = ref([]);
const loading = ref(false);
const finished = ref(false);
const refreshing = ref(false);

const isEditMode = ref(false);
const checkedIds = ref([]);
const checkedAll = ref(false);

const onClickLeft = () => {
    if (isEditMode.value) {
        isEditMode.value = false;
        checkedIds.value = [];
    } else {
        router.back();
    }
};

const toggleEditMode = () => {
    isEditMode.value = !isEditMode.value;
    if (!isEditMode.value) {
        checkedIds.value = [];
    }
};

const onLoad = async () => {
    if (refreshing.value) {
        list.value = [];
        refreshing.value = false;
    }
    
    try {
        const url = isHistory.value ? '/history' : '/favorites';
        const res = await request.get(url);
        list.value = res;
        loading.value = false;
        finished.value = true;
    } catch (error) {
        loading.value = false;
        finished.value = true;
    }
};

const onRefresh = () => {
    finished.value = false;
    loading.value = true;
    onLoad();
};

const goDetail = (id) => {
    if (!isEditMode.value) {
        router.push(`/product/${id}`);
    } else {
        // 编辑模式下点击也可以选中
        const index = checkedIds.value.indexOf(id);
        if (index > -1) {
            checkedIds.value.splice(index, 1);
        } else {
            checkedIds.value.push(id);
        }
    }
};

// 监听选中项变化，更新全选状态
watch(checkedIds, (newVal) => {
    checkedAll.value = newVal.length > 0 && newVal.length === list.value.length;
}, { deep: true });

const toggleAll = () => {
    if (checkedAll.value) {
        checkedIds.value = list.value.map(item => item.id);
    } else {
        checkedIds.value = [];
    }
};

// 单个删除
const onDeleteOne = async (id) => {
    // 阻止冒泡
    showDialog({
        title: '提示',
        message: '确认删除该记录吗？',
        showCancelButton: true
    }).then(async (action) => {
        if (action === 'confirm') {
            await doDelete([id]);
        }
    });
};

// 批量删除
const onBatchDelete = () => {
    if (checkedIds.value.length === 0) {
        showToast('请选择要删除的记录');
        return;
    }
    showDialog({
        title: '提示',
        message: `确认删除选中的 ${checkedIds.value.length} 条记录吗？`,
        showCancelButton: true
    }).then(async (action) => {
        if (action === 'confirm') {
            await doDelete(checkedIds.value);
            isEditMode.value = false;
            checkedIds.value = [];
        }
    });
};

const doDelete = async (ids) => {
    try {
        const url = isHistory.value ? '/history' : '/favorites';
        // axios delete 传参需要用 data 属性
        await request.delete(url, { data: { ids } });
        showToast('删除成功');
        // 本地移除
        list.value = list.value.filter(item => !ids.includes(item.id));
    } catch (error) {
        showToast('删除失败');
    }
};

const formatTime = (timeStr) => {
    if (!timeStr) return '';
    const date = new Date(timeStr);
    return `${date.getMonth() + 1}-${date.getDate()} ${date.getHours()}:${date.getMinutes()}`;
};
</script>

<style lang="less" scoped>
.common-list-page {
  min-height: 100vh;
  background-color: #f7f8fa;
  padding-bottom: 50px; // 防止被 submit-bar 遮挡
}

.goods-list {
  padding: 10px;
}

.goods-item-wrapper {
  background: #fff;
  border-radius: 8px;
  overflow: hidden;
  margin-bottom: 10px;
  display: flex;
  align-items: center;
  
  .item-checkbox {
      padding-left: 10px;
      margin-right: -5px; // 调整间距
  }
  
  .goods-swipe-cell {
      flex: 1;
      min-width: 0; // 使用 min-width: 0 替代 width: 0，避免宽度塌陷同时保持 flex 收缩特性
  }
}

.goods-item {
  display: flex;
  padding: 10px;
  background: #fff;
  width: 100%; // 确保内容占满
  box-sizing: border-box; // 包含 padding
  
  .goods-img {
    width: 100px;
    height: 100px;
    flex-shrink: 0;
    margin-right: 10px;
    img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      border-radius: 4px;
    }
  }
  
  .goods-info {
    flex: 1;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    
    .goods-name {
      font-size: 14px;
      color: #333;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
      line-height: 1.4;
    }
    
    .goods-price {
      color: #ee0a24;
      display: flex;
      align-items: baseline;
      
      .price-symbol {
        font-size: 12px;
      }
      .price-num {
        font-size: 16px;
        font-weight: bold;
        margin-right: 10px;
      }
      .time-tip {
          font-size: 12px;
          color: #999;
          margin-left: auto;
      }
    }
  }
}

.delete-button {
  height: 100%;
}

.edit-footer {
    bottom: 0;
}
</style>