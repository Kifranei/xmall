<template>
  <div class="account-security-page">
    <van-nav-bar
      title="账号与安全"
      left-arrow
      @click-left="onClickLeft"
    />
    
    <van-cell-group inset class="group">
      <van-cell title="手机号" :value="maskedMobile" is-link to="/user/change-mobile" />
      <van-cell title="登录密码" value="修改" is-link to="/user/change-password" />
    </van-cell-group>
  </div>
</template>

<script setup>
import { computed } from 'vue';
import { useRouter } from 'vue-router';
import { useUserStore } from '../../../store/user';

const router = useRouter();
const userStore = useUserStore();

// 模拟获取用户手机号，实际应在 store 或接口中
const mobile = '13800138000';
const maskedMobile = computed(() => {
    return mobile.replace(/(\d{3})\d{4}(\d{4})/, '$1****$2');
});

const onClickLeft = () => router.back();
</script>

<style lang="less" scoped>
.account-security-page {
  min-height: 100vh;
  background-color: #f7f8fa;
  padding-top: 10px;
}
.group {
    margin-top: 10px;
}
</style>