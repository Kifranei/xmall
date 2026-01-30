<template>
  <div class="change-mobile-page">
    <van-nav-bar
      title="修改手机号"
      left-arrow
      @click-left="onClickLeft"
    />
    
    <div class="form-content">
      <div class="tip">为了您的账号安全，请验证新手机号</div>
      <van-form @submit="onSubmit">
        <van-cell-group inset>
          <van-field
            v-model="mobile"
            name="mobile"
            label="新手机号"
            placeholder="请输入新手机号"
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

const mobile = ref('');
const code = ref('');
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
    showToast('修改成功');
    router.back();
};
</script>

<style lang="less" scoped>
.change-mobile-page {
  min-height: 100vh;
  background-color: #f7f8fa;
}
.form-content {
    margin-top: 20px;
    .tip {
        padding: 0 16px 10px;
        font-size: 14px;
        color: #999;
    }
}
</style>