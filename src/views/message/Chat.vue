<template>
  <div class="chat-page">
    <van-nav-bar
      :title="title"
      left-arrow
      @click-left="onClickLeft"
      fixed
      placeholder
    />
    
    <div class="chat-content" ref="chatContentRef">
      <div class="msg-item" v-for="(msg, index) in messages" :key="index" :class="{ 'is-me': msg.isMe }">
        <div class="avatar" v-if="!msg.isMe">
          <img :src="targetAvatar" alt="">
        </div>
        <div class="bubble">
          {{ msg.content }}
        </div>
        <div class="avatar" v-if="msg.isMe">
          <img :src="myAvatar" alt="">
        </div>
      </div>
    </div>
    
    <div class="chat-footer">
      <input type="text" v-model="inputValue" placeholder="请输入消息..." @keyup.enter="sendMsg">
      <van-button type="primary" size="small" @click="sendMsg" :disabled="!inputValue.trim()">发送</van-button>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useUserStore } from '../../store/user';

const route = useRoute();
const router = useRouter();
const userStore = useUserStore();

const title = ref('聊天中');
const inputValue = ref('');
const chatContentRef = ref(null);

const myAvatar = userStore.userInfo.avatar || 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg';
const targetAvatar = 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg'; // 对方头像模拟

const messages = ref([
  { content: '你好，请问有什么可以帮您？', isMe: false },
]);

onMounted(() => {
  const id = route.params.id;
  if (id === '1') {
      title.value = '官方客服';
  } else if (id === '2') {
      title.value = '系统通知';
      messages.value = [{ content: '您的订单已发货，请注意查收', isMe: false }];
  }
});

const onClickLeft = () => {
  router.back();
};

const sendMsg = () => {
  if (!inputValue.value.trim()) return;
  
  messages.value.push({
    content: inputValue.value,
    isMe: true
  });
  inputValue.value = '';
  
  scrollToBottom();
  
  // 模拟回复
  setTimeout(() => {
    messages.value.push({
      content: '收到您的消息，我们会尽快处理。',
      isMe: false
    });
    scrollToBottom();
  }, 1000);
};

const scrollToBottom = () => {
  nextTick(() => {
    if (chatContentRef.value) {
        window.scrollTo(0, document.body.scrollHeight);
    }
  });
};
</script>

<style lang="less" scoped>
.chat-page {
  min-height: 100vh;
  background-color: #f7f8fa;
  padding-bottom: 60px;
}

.chat-content {
  padding: 15px;
}

.msg-item {
  display: flex;
  margin-bottom: 15px;
  
  .avatar {
    width: 40px;
    height: 40px;
    flex-shrink: 0;
    img {
      width: 100%;
      height: 100%;
      border-radius: 4px;
    }
  }
  
  .bubble {
    max-width: 70%;
    padding: 10px 14px;
    border-radius: 8px;
    font-size: 14px;
    line-height: 1.5;
    word-break: break-all;
    position: relative;
  }
  
  &.is-me {
    justify-content: flex-end;
    .bubble {
      background-color: #1989fa;
      color: #fff;
      margin-right: 10px;
      border-top-right-radius: 2px;
    }
  }
  
  &:not(.is-me) {
    justify-content: flex-start;
    .bubble {
      background-color: #fff;
      color: #333;
      margin-left: 10px;
      border-top-left-radius: 2px;
    }
  }
}

.chat-footer {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  background: #fff;
  padding: 10px;
  display: flex;
  align-items: center;
  border-top: 1px solid #ebedf0;
  
  input {
    flex: 1;
    height: 36px;
    border: none;
    background: #f5f6f7;
    border-radius: 18px;
    padding: 0 15px;
    margin-right: 10px;
    font-size: 14px;
  }
}
</style>