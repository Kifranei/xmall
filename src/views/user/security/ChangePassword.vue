<template>
  <div class="change-password-page">
    <van-nav-bar
      title="修改密码"
      left-arrow
      @click-left="onClickLeft"
    />
    
    <div class="form-content">
      <van-form @submit="onSubmit">
        <van-cell-group inset>
          <van-field
            v-model="oldPassword"
            type="password"
            name="oldPassword"
            label="旧密码"
            placeholder="请输入旧密码"
            :rules="[{ required: true, message: '请填写旧密码' }]"
          />
          <van-field
            v-model="newPassword"
            type="password"
            name="newPassword"
            label="新密码"
            placeholder="请输入新密码"
            :rules="[{ required: true, message: '请填写新密码' }]"
          />
          <van-field
            v-model="confirmPassword"
            type="password"
            name="confirmPassword"
            label="确认密码"
            placeholder="请再次输入新密码"
            :rules="[{ required: true, message: '请确认新密码' }]"
          />
        </van-cell-group>
        <div style="margin: 16px;">
          <van-button round block type="primary" native-type="submit">
            确认修改
          </van-button>
        </div>
      </van-form>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { showToast } from 'vant';

const router = useRouter();

const oldPassword = ref('');
const newPassword = ref('');
const confirmPassword = ref('');

const onClickLeft = () => router.back();

const onSubmit = (values) => {
    if (newPassword.value !== confirmPassword.value) {
        showToast('两次输入的密码不一致');
        return;
    }
    showToast('修改成功，请重新登录');
    // 实际应调用退出登录逻辑
    router.replace('/login');
};
</script>

<style lang="less" scoped>
.change-password-page {
  min-height: 100vh;
  background-color: #f7f8fa;
}
.form-content {
    margin-top: 20px;
}
</style>