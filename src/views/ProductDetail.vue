<template>
  <div class="product-detail">
    <van-nav-bar
      title="商品详情"
      left-text="返回"
      left-arrow
      @click-left="onClickLeft"
      fixed
      placeholder
    />

    <van-swipe :autoplay="3000" indicator-color="white" class="goods-swipe">
      <van-swipe-item v-for="(img, index) in images" :key="index">
        <img :src="img" />
      </van-swipe-item>
    </van-swipe>

    <div class="goods-info">
      <div class="price">¥ {{ product.price }}</div>
      <div class="title">{{ product.name }}</div>
      <div class="desc">{{ product.description || '这里是商品的详细描述信息，模拟拼多多的商品展示。' }}</div>
    </div>
    
    <van-cell-group class="goods-cell-group">
      <van-cell title="发货" value="浙江杭州 | 快递: 免运费" icon="location-o" />
      <van-cell title="保障" value="假一赔十 · 极速退款 · 七天无理由" icon="passed" />
    </van-cell-group>

    <div class="goods-detail-content">
       <van-divider>商品详情</van-divider>
       <div class="content-body">
         <img v-if="product.main_image" :src="product.main_image" style="width:100%" />
         <p>商品详细介绍文本...</p>
       </div>
    </div>

    <van-action-bar>
      <van-action-bar-icon icon="chat-o" text="客服" @click="goChat" />
      <van-action-bar-icon 
        :icon="isFavorite ? 'star' : 'star-o'" 
        :text="isFavorite ? '已收藏' : '收藏'" 
        :color="isFavorite ? '#ff5000' : ''" 
        @click="toggleFavorite" 
      />
      <van-action-bar-icon icon="cart-o" text="购物车" :badge="cartStore.totalCount > 0 ? cartStore.totalCount : ''" @click="router.push('/cart')" />
      <van-action-bar-button type="warning" text="加入购物车" @click="addCart" />
      <van-action-bar-button type="danger" text="立即购买" @click="buyNow" />
    </van-action-bar>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useCartStore } from '../store/cart';
import { useUserStore } from '../store/user';
import { showToast, showDialog } from 'vant';
import 'vant/es/dialog/style';
import 'vant/es/toast/style'; 
import request from '../utils/request';

const route = useRoute();
const router = useRouter();
const cartStore = useCartStore();
const userStore = useUserStore();

const product = ref({
  id: route.params.id,
  name: '加载中...',
  price: '0.00'
});

const isFavorite = ref(false);

const images = computed(() => {
    if (product.value.images) {
        try {
            return JSON.parse(product.value.images);
        } catch (e) {
            return [product.value.main_image];
        }
    }
    return [product.value.main_image || 'https://fastly.jsdelivr.net/npm/@vant/assets/apple-1.jpeg'];
});

onMounted(async () => {
  const productId = route.params.id;
  try {
    const res = await request.get(`/products/${productId}`);
    product.value = {
        ...res,
        img: res.main_image 
    };
    
    // 检查收藏状态
    checkFavorite(productId);
    
    // 记录浏览历史
    addHistory(productId);
    
  } catch (error) {
    showToast('商品加载失败');
  }
});

const checkFavorite = async (id) => {
    try {
        const res = await request.get('/favorite/check', { params: { productId: id } });
        isFavorite.value = res;
    } catch (error) {
        console.error(error);
    }
};

const checkLogin = () => {
    if (!userStore.isLogin) {
        showToast('未登录，请先登录');
        setTimeout(() => {
            router.push('/login');
        }, 500);
        return false;
    }
    return true;
};

const toggleFavorite = async () => {
    if (!checkLogin()) return;
    try {
        const res = await request.post('/favorite', { productId: product.value.id });
        isFavorite.value = res;
        showToast(res ? '收藏成功' : '已取消收藏');
    } catch (error) {
        showToast('操作失败');
    }
};

const addHistory = async (id) => {
    // 浏览历史可以记录，不需要登录
    try {
        await request.post('/history', { productId: id });
    } catch (error) {
        console.error('记录历史失败', error);
    }
};

const goChat = () => {
    // 客服 ID 暂时写死为 1
    router.push('/message/chat/1');
};

const onClickLeft = () => {
  router.back();
};

const addCart = () => {
  if (!checkLogin()) return;
  cartStore.addToCart(product.value);
  showToast('加入购物车成功');
};

const buyNow = () => {
  if (!checkLogin()) return;
  showToast('点击了立即购买');
};
</script>

<style lang="less" scoped>
.product-detail {
  padding-bottom: 50px;
}
.goods-swipe img {
  width: 100%;
  height: 300px;
  object-fit: cover;
}
.goods-info {
  padding: 15px;
  background: #fff;
  margin-bottom: 10px;
  
  .price {
    color: #ee0a24;
    font-size: 24px;
    font-weight: bold;
    margin-bottom: 10px;
  }
  .title {
    font-size: 16px;
    font-weight: bold;
    line-height: 1.5;
    margin-bottom: 10px;
  }
  .desc {
    font-size: 12px;
    color: #999;
  }
}
.goods-cell-group {
  margin-bottom: 10px;
}
.goods-detail-content {
  background: #fff;
  padding: 10px;
  min-height: 200px;
}
</style>
