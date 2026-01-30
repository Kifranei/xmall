<template>
  <div class="refund-list">
    <van-nav-bar
      title="退款/售后"
      left-arrow
      @click-left="onClickLeft"
      fixed
      placeholder
    />

    <van-tabs v-model:active="active" sticky>
      <van-tab title="全部" name="0"></van-tab>
      <van-tab title="处理中" name="1"></van-tab>
      <van-tab title="退款成功" name="2"></van-tab>
    </van-tabs>

    <van-pull-refresh v-model="refreshing" @refresh="onRefresh">
      <van-list
        v-model:loading="loading"
        :finished="finished"
        finished-text="没有更多了"
        @load="onLoad"
      >
        <div class="order-item" v-for="order in list" :key="order.id">
          <div class="order-header">
            <span class="order-no">订单号：{{ order.order_no }}</span>
            <span class="order-status">退款成功</span>
          </div>
          
          <div class="order-body" v-for="item in order.items" :key="item.id">
            <van-card
              :num="item.quantity"
              :price="item.price"
              :title="item.product_name"
              :thumb="item.product_image"
            />
          </div>
          
          <div class="order-footer">
            <div class="total-price">
              退款金额：<span>¥ {{ order.total_amount }}</span>
            </div>
            <div class="action-btns">
               <van-button size="small" round plain @click="goDetail(order.id)">查看详情</van-button>
            </div>
          </div>
        </div>
        <van-empty v-if="list.length === 0 && finished" description="暂无退款/售后记录" />
      </van-list>
    </van-pull-refresh>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import request from '../../utils/request';

const router = useRouter();

const active = ref('0');
const list = ref([]);
const loading = ref(false);
const finished = ref(false);
const refreshing = ref(false);

const onClickLeft = () => router.back();

const goDetail = (id) => {
    router.push(`/order/${id}`);
};

const onLoad = async () => {
  if (refreshing.value) {
    list.value = [];
    refreshing.value = false;
  }

  try {
    // 这里的 status=5 对应后端的“已取消/退款”状态
    // 实际项目中可能需要更复杂的筛选逻辑
    const res = await request.get('/orders', {
      params: {
        status: 5 
      }
    });
    
    // 简单前端过滤模拟 tab 切换
    // 假设 status 5 都是退款成功
    if (active.value === '1') {
        list.value = []; // 暂时没有处理中的
    } else {
        list.value = res;
    }
    
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
</script>

<style lang="less" scoped>
.refund-list {
  min-height: 100vh;
  background-color: #f7f8fa;
}
.order-item {
  background: #fff;
  margin-top: 10px;
  padding: 10px;
  
  .order-header {
    display: flex;
    justify-content: space-between;
    font-size: 12px;
    color: #666;
    margin-bottom: 10px;
    padding-bottom: 10px;
    border-bottom: 1px solid #ebedf0;
    
    .order-status {
      color: #ee0a24;
    }
  }
  
  .order-footer {
    text-align: right;
    margin-top: 10px;
    
    .total-price {
      font-size: 12px;
      margin-bottom: 10px;
      span {
        font-size: 14px;
        font-weight: bold;
      }
    }
    
    .action-btns {
      .van-button {
        margin-left: 10px;
      }
    }
  }
}
</style>