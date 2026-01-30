<template>
  <div class="message-list-page">
    <van-nav-bar title="消息" fixed placeholder />
    
    <div v-if="userStore.isLogin">
      <div class="message-list">
        <div class="message-item" v-for="item in list" :key="item.id" @click="goChat(item.id)">
          <div class="avatar">
            <img :src="item.avatar" alt="">
            <div class="badge" v-if="item.unread > 0">{{ item.unread }}</div>
          </div>
          <div class="content">
            <div class="top-row">
              <span class="name">{{ item.name }}</span>
              <span class="time">{{ item.time }}</span>
            </div>
            <div class="bottom-row">
              <span class="last-msg">{{ item.lastMsg }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <van-empty v-else description="您还没有登录，请先登录">
      <van-button round type="primary" class="bottom-button" @click="router.push('/login')">
        去登录
      </van-button>
    </van-empty>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useUserStore } from '../../store/user';

const router = useRouter();
const userStore = useUserStore();

const list = ref([
  {
    id: 1,
    name: '官方客服',
    avatar: 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg',
    lastMsg: '亲，请问有什么可以帮您？',
    time: '12:30',
    unread: 2
  },
  {
    id: 2,
    name: '系统通知',
    avatar: 'https://fastly.jsdelivr.net/npm/@vant/assets/leaf.jpeg',
    lastMsg: '您的订单已发货，请注意查收',
    time: '昨天',
    unread: 0
  }
]);

const goChat = (id) => {
  router.push(`/message/chat/${id}`);
};
</script>

<style lang="less" scoped>
.message-list-page {
  min-height: 100vh;
  background-color: #fff;
  padding-bottom: 50px;
}

.message-item {
  display: flex;
  padding: 15px;
  border-bottom: 1px solid #f5f6f7;
  
  &:active {
    background-color: #f9f9f9;
  }
  
  .avatar {
    position: relative;
    width: 50px;
    height: 50px;
    margin-right: 15px;
    
    img {
      width: 100%;
      height: 100%;
      border-radius: 50%;
      object-fit: cover;
    }
    
    .badge {
      position: absolute;
      top: -2px;
      right: -2px;
      background-color: #ee0a24;
      color: #fff;
      font-size: 10px;
      padding: 0 4px;
      height: 14px;
      line-height: 14px;
      border-radius: 7px;
      border: 1px solid #fff;
    }
  }
  
  .content {
    flex: 1;
    display: flex;
    flex-direction: column;
    justify-content: center;
    
    .top-row {
      display: flex;
      justify-content: space-between;
      margin-bottom: 5px;
      
      .name {
        font-size: 16px;
        color: #333;
        font-weight: 500;
      }
      
      .time {
        font-size: 12px;
        color: #999;
      }
    }
    
    .bottom-row {
      .last-msg {
        font-size: 14px;
        color: #999;
        display: -webkit-box;
        -webkit-line-clamp: 1;
        -webkit-box-orient: vertical;
        overflow: hidden;
      }
    }
  }
}
</style>