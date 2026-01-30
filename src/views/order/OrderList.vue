<template>
  <div class="order-list">
    <van-nav-bar
      title="我的订单"
      left-arrow
      @click-left="onClickLeft"
      fixed
      placeholder
    />
    
    <van-tabs v-model:active="active" sticky @change="onTabChange">
      <van-tab title="全部" name="0"></van-tab>
      <van-tab title="待付款" name="1"></van-tab>
      <van-tab title="待发货" name="2"></van-tab>
      <van-tab title="待收货" name="3"></van-tab>
      <van-tab title="待评价" name="4"></van-tab>
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
            <span class="order-status">{{ getStatusText(order.status) }}</span>
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
              共 {{ order.items ? order.items.length : 0 }} 件商品  合计：<span>¥ {{ order.total_amount }}</span>
            </div>
            <div class="action-btns">
               <van-button size="small" round v-if="order.status === 0">去支付</van-button>
               <van-button size="small" round v-if="order.status === 2">确认收货</van-button>
               <van-button size="small" round plain @click="goDetail(order.id)">查看详情</van-button>
            </div>
          </div>
        </div>
      </van-list>
    </van-pull-refresh>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import request from '../../utils/request';

const router = useRouter();
const route = useRoute();

const active = ref(route.query.type || '0');
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
    const res = await request.get('/orders', {
      params: {
        status: active.value
      }
    });
    
    // 这里简单处理，一次性加载所有
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

const onTabChange = (name) => {
    active.value = name;
    list.value = [];
    loading.value = true;
    finished.value = false;
    onLoad();
};

const getStatusText = (status) => {
    const map = {
        0: '待付款',
        1: '待发货',
        2: '待收货',
        3: '已完成',
        4: '已取消'
    };
    return map[status] || '';
};
</script>

<style lang="less" scoped>
.order-list {
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