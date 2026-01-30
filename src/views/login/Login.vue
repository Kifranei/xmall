<template>
  <div class="login-page">
    <van-nav-bar
      title="登录"
      left-arrow
      @click-left="onClickLeft"
    />
    
    <div class="login-form">
      <div class="logo">
        <img src="https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg" alt="">
        <h3>XMall 商城</h3>
      </div>
      
      <van-form @submit="onSubmit">
        <van-cell-group inset>
          <van-field
            v-model="username"
            name="username"
            label="账号"
            placeholder="账号/手机号"
            :rules="[{ required: true, message: '请填写账号' }]"
          />
          <van-field
            v-model="password"
            type="password"
            name="password"
            label="密码"
            placeholder="密码"
            :rules="[{ required: true, message: '请填写密码' }]"
          />
        </van-cell-group>
        <div style="margin: 16px;">
          <van-button round block type="primary" native-type="submit">
            登录
          </van-button>
        </div>
      </van-form>
      
      <div class="action-links">
        <span @click="router.push('/register')">注册账号</span>
        <span class="divider">|</span>
        <span @click="router.push('/forgot-password')">忘记密码</span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useUserStore } from '../../store/user';
import { showToast } from 'vant';

const router = useRouter();
const userStore = useUserStore();

const username = ref('');
const password = ref('');

const onClickLeft = () => {
    // 如果有上一页历史则返回，否则回首页
    if (window.history.length > 1) {
        router.back();
    } else {
        router.replace('/');
    }
};

const onSubmit = (values) => {
  // 模拟登录
  if (values.username && values.password) {
      showToast('登录成功');
      userStore.login({
          username: values.username,
          // 实际应该后端返回 token 和用户信息
      });
      onClickLeft();
  }
};
</script>

<style lang="less" scoped>
.login-page {
  min-height: 100vh;
  background-color: #fff;
}

.login-form {
  padding-top: 50px;
  
  .logo {
    text-align: center;
    margin-bottom: 40px;
    img {
      width: 80px;
      height: 80px;
      border-radius: 50%;
    }
    h3 {
      margin-top: 10px;
      color: #333;
    }
  }
  
  .action-links {
    text-align: center;
    margin-top: 20px;
    font-size: 14px;
    color: #1989fa;
    
    .divider {
      margin: 0 10px;
      color: #ddd;
    }
  }
}
</style>