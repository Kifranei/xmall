<template>
  <div class="home">
    <!-- 顶部搜索 -->
    <van-sticky>
      <van-search
        v-model="searchValue"
        shape="round"
        background="#fff"
        placeholder="请输入搜索关键词"
        @click-input="onSearchFocus"
      />
    </van-sticky>

    <!-- 轮播图 -->
    <van-swipe class="my-swipe" :autoplay="3000" indicator-color="white">
      <van-swipe-item v-for="(image, index) in banners" :key="index">
        <img :src="image" style="width: 100%; height: 100%; object-fit: cover;" />
      </van-swipe-item>
    </van-swipe>

    <!-- 金刚区 -->
    <van-grid :column-num="5" :border="false">
      <van-grid-item v-for="item in navList" :key="item.text" :icon="item.icon" :text="item.text" />
    </van-grid>

    <!-- 商品列表 -->
    <div class="goods-title">{{ listTitle }}</div>
    <van-list
      v-model:loading="loading"
      :finished="finished"
      finished-text="没有更多了"
      @load="onLoad"
    >
      <div class="goods-list">
        <div class="goods-item" v-for="item in list" :key="item.id" @click="goDetail(item.id)">
          <div class="goods-img">
            <img :src="item.img" alt="">
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
    </van-list>
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import request from '../utils/request';

const router = useRouter();
const route = useRoute();
const searchValue = ref('');
const loading = ref(false);
const finished = ref(false);
const list = ref([]);
const page = ref(1);
const pageSize = 10;

// 监听路由参数变化，处理搜索
const listTitle = computed(() => {
  return route.query.q ? `"${route.query.q}" 的搜索结果` : '热门推荐';
});

// 如果有搜索参数，初始化时可以清空列表重新加载
watch(() => route.query.q, (newVal) => {
  searchValue.value = newVal || '';
  refreshList();
});

const refreshList = () => {
  list.value = [];
  page.value = 1;
  finished.value = false;
  loading.value = true;
  onLoad();
}

const banners = [
  'https://fastly.jsdelivr.net/npm/@vant/assets/apple-1.jpeg',
  'https://fastly.jsdelivr.net/npm/@vant/assets/apple-2.jpeg',
  'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg',
];

const navList = [
  { text: '限时秒杀', icon: 'clock-o' },
  { text: '断码清仓', icon: 'bag-o' },
  { text: '百亿补贴', icon: 'balance-o' },
  { text: '多多果园', icon: 'flower-o' },
  { text: '充值中心', icon: 'phone-o' },
];

const onLoad = async () => {
  try {
    const res = await request.get('/products', {
      params: {
        page: page.value,
        pageSize: pageSize,
        keyword: route.query.q || ''
      }
    });

    const products = res.list.map(item => ({
      ...item,
      img: item.main_image // 映射后端字段
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

const onSearchFocus = () => {
  // router.push('/search'); // 之前是跳转到分类搜索页
  // 如果是点击输入框，我们通常是想去一个专门的“搜索输入页”或者就在当前页输入
  // 这里假设点击就去分类搜索页（Search.vue），在 Search.vue 里输入关键词后跳到 SearchResult
  router.push('/search');
};

const goDetail = (id) => {
  router.push(`/product/${id}`);
};
</script>

<style lang="less" scoped>
.home {
  padding-bottom: 20px;
}
.my-swipe .van-swipe-item {
  color: #fff;
  font-size: 20px;
  line-height: 150px;
  text-align: center;
  background-color: #39a9ed;
  height: 180px;
}
.goods-title {
  padding: 15px;
  font-size: 16px;
  font-weight: bold;
  color: #ee0a24;
  text-align: center;
}
.goods-list {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  padding: 0 10px;
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
