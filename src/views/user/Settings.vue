<template>
  <div class="settings-page">
    <van-nav-bar title="设置" left-arrow @click-left="onClickLeft" />
    
    <van-cell-group title="账号与安全">
      <van-cell title="个人资料" is-link to="/settings/profile" />
      <van-cell title="账号安全" is-link to="/settings/security" />
    </van-cell-group>
    
    <van-cell-group title="通用">
      <van-cell title="关于我们" value="v1.0.0" />
      <van-cell title="清除缓存" is-link />
    </van-cell-group>
    
    <div class="logout-btn">
      <van-button block type="default" @click="handleLogout">退出登录</van-button>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router';
import { useUserStore } from '../../store/user';
import { showDialog, showToast } from 'vant';
import 'vant/es/dialog/style';
import 'vant/es/toast/style';

const router = useRouter();
const userStore = useUserStore();

const onClickLeft = () => router.back();

const handleLogout = () => {
  showDialog({
    title: '提示',
    message: '确认要退出登录吗？',
    showCancelButton: true,
  }).then((action) => {
    if (action === 'confirm') {
      userStore.logout();
      showToast('已退出登录');
      router.back();
    }
  });
};
</script>

<style lang="less" scoped>
.settings-page {
  min-height: 100vh;
  background-color: #f7f8fa;
}
.logout-btn {
  margin-top: 20px;
  padding: 0 16px;
  
  .van-button {
      color: #ee0a24;
  }
}
</style>