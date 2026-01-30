<template>
  <div class="forgot-password-page">
    <van-nav-bar
      title="找回密码"
      left-arrow
      @click-left="onClickLeft"
    />
    
    <div class="form-content">
      <van-form @submit="onSubmit">
        <van-cell-group inset>
          <van-field
            v-model="mobile"
            name="mobile"
            label="手机号"
            placeholder="请输入手机号"
            :rules="[{ required: true, message: '请填写手机号' }]"
          />
          <van-field
            v-model="code"
            name="code"
            label="验证码"
            placeholder="请输入验证码"
            :rules="[{ required: true, message: '请填写验证码' }]"
          >
            <template #button>
              <van-button size="small" type="primary" :disabled="isSending" @click="sendCode">
                {{ isSending ? `${countdown}s` : '发送验证码' }}
              </van-button>
            </template>
          </van-field>
          <van-field
            v-model="password"
            type="password"
            name="password"
            label="新密码"
            placeholder="请设置新密码"
            :rules="[{ required: true, message: '请填写新密码' }]"
          />
        </van-cell-group>
        <div style="margin: 16px;">
          <van-button round block type="primary" native-type="submit">
            重置密码
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

const mobile = ref('');
const code = ref('');
const password = ref('');
const isSending = ref(false);
const countdown = ref(60);

const onClickLeft = () => router.back();

const sendCode = () => {
    if (!mobile.value) {
        showToast('请输入手机号');
        return;
    }
    isSending.value = true;
    showToast('验证码已发送');
    const timer = setInterval(() => {
        countdown.value--;
        if (countdown.value <= 0) {
            clearInterval(timer);
            isSending.value = false;
            countdown.value = 60;
        }
    }, 1000);
};

const onSubmit = (values) => {
    showToast('密码重置成功，请登录');
    router.replace('/login');
};
</script>

<style lang="less" scoped>
.forgot-password-page {
  min-height: 100vh;
  background-color: #f7f8fa;
}
.form-content {
    margin-top: 20px;
}
</style>