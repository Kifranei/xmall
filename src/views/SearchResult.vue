<template>
  <div class="search-result-page">
    <van-nav-bar
      left-arrow
      @click-left="onClickLeft"
      fixed
      placeholder
    >
      <template #title>
        <van-search
          v-model="searchValue"
          shape="round"
          placeholder="请输入搜索关键词"
          @search="onSearch"
          class="nav-search"
        />
      </template>
    </van-nav-bar>

    <van-pull-refresh v-model="refreshing" @refresh="onRefresh">
      <van-list
        v-model:loading="loading"
        :finished="finished"
        finished-text="没有更多了"
        @load="onLoad"
      >
        <div class="goods-list">
          <div class="goods-item" v-for="item in list" :key="item.id" @click="goDetail(item.id)">
            <div class="goods-img">
              <img :src="item.main_image" alt="">
            </div>
            <div class="goods-info">
              <div class="goods-name">{{ item.name }}</div>
              <div class="goods-price">
                <span class="price-symbol">¥</span>
                <span class="price-num">{{ item.price }}</span>
                <span class="goods-sales">已拼{{ item.sales }}件</span>
              </div>
            </div>
          </div>
        </div>
        <van-empty v-if="list.length === 0 && finished" description="未找到相关商品" />
      </van-list>
    </van-pull-refresh>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import request from '../utils/request';

const route = useRoute();
const router = useRouter();

const searchValue = ref(route.query.q || '');
const list = ref([]);
const loading = ref(false);
const finished = ref(false);
const refreshing = ref(false);
const page = ref(1);
const pageSize = 10;

const onClickLeft = () => {
    router.back();
};

const onSearch = () => {
    list.value = [];
    page.value = 1;
    finished.value = false;
    loading.value = true;
    onLoad();
    // 更新路由参数，方便分享或刷新
    router.replace({ query: { ...route.query, q: searchValue.value } });
};

const onLoad = async () => {
    if (refreshing.value) {
        list.value = [];
        page.value = 1;
        refreshing.value = false;
    }

    try {
        const res = await request.get('/products', {
            params: {
                page: page.value,
                pageSize: pageSize,
                keyword: searchValue.value
            }
        });

        const products = res.list.map(item => ({
            ...item,
            // 确保图片字段一致
        }));

        list.value.push(...products);
        page.value++;
        loading.value = false;

        if (list.value.length >= res.total) {
            finished.value = true;
        }
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
    router.push(`/product/${id}`);
};
</script>

<style lang="less" scoped>
.search-result-page {
  min-height: 100vh;
  background-color: #f7f8fa;
}

.nav-search {
    padding: 0;
    background: transparent;
    width: 100%;
}

:deep(.van-nav-bar__title) {
    max-width: 80%;
    width: 80%;
}

.goods-list {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  padding: 10px;
}

.goods-item {
  width: 48%;
  background: #fff;
  border-radius: 8px;
  overflow: hidden;
  margin-bottom: 10px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  
  .goods-img {
    width: 100%;
    height: 170px;
    img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
  }
  
  .goods-info {
    padding: 8px;
    
    .goods-name {
      font-size: 14px;
      color: #333;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
      margin-bottom: 5px;
      height: 40px;
    }
    
    .goods-price {
      color: #ee0a24;
      display: flex;
      align-items: baseline;
      
      .price-symbol {
        font-size: 12px;
      }
      .price-num {
        font-size: 18px;
        font-weight: bold;
      }
      .goods-sales {
        color: #999;
        font-size: 12px;
        margin-left: auto;
      }
    }
  }
}
</style>