<template>
  <div class="app-container">
    <router-view />
    
    <van-tabbar v-if="route.meta.showTabbar" route fixed placeholder>
      <van-tabbar-item replace to="/" icon="home-o">首页</van-tabbar-item>
      <van-tabbar-item replace to="/search" icon="search">分类</van-tabbar-item>
      <van-tabbar-item replace to="/message" icon="chat-o">消息</van-tabbar-item>
      <van-tabbar-item replace to="/cart" icon="shopping-cart-o">购物车</van-tabbar-item>
      <van-tabbar-item replace to="/profile" icon="user-o">我的</van-tabbar-item>
    </van-tabbar>
  </div>
</template>

<script setup>
import { useRoute } from 'vue-router';
const route = useRoute();
</script>

<style>
body {
  margin: 0;
  padding: 0;
  background-color: #f7f8fa;
}
#app {
  max-width: 100%;
  margin: 0 auto;
  font-family: -apple-system, BlinkMacSystemFont, 'Helvetica Neue', Helvetica, Segoe UI, Arial, Roboto, 'PingFang SC', 'miui', 'Hiragino Sans GB', 'Microsoft Yahei', sans-serif;
}
</style>
