<template>
  <div class="profile-page">
    <div class="user-header" @click="handleLogin">
      <div class="user-header-content">
        <van-image
          round
          width="60px"
          height="60px"
          :src="userStore.userInfo.avatar"
          class="avatar"
        />
        <div class="user-info">
          <div class="username">{{ userStore.userInfo.nickname }}</div>
          <div class="user-id" v-if="userStore.isLogin">ID: {{ userStore.userInfo.userId }}</div>
          <div class="user-tips" v-else>登录后享受更多优惠</div>
        </div>
        <van-icon name="arrow" class="arrow-icon" v-if="!userStore.isLogin" />
      </div>
    </div>

    <!-- 钱包区域 -->
    <van-cell-group inset class="wallet-group" v-if="userStore.isLogin">
      <van-grid :column-num="3" :border="false">
        <van-grid-item>
          <div class="wallet-num">{{ userStore.userInfo.balance }}</div>
          <div class="wallet-text">余额</div>
        </van-grid-item>
        <van-grid-item>
          <div class="wallet-num">{{ userStore.userInfo.points }}</div>
          <div class="wallet-text">积分</div>
        </van-grid-item>
        <van-grid-item>
          <div class="wallet-num">{{ userStore.userInfo.coupons }}</div>
          <div class="wallet-text">优惠券</div>
        </van-grid-item>
      </van-grid>
    </van-cell-group>

    <van-cell-group class="order-group" inset v-if="userStore.isLogin">
      <van-cell title="我的订单" value="查看全部" is-link to="/order?type=0" />
      <van-grid :border="false">
        <van-grid-item icon="pending-payment" text="待付款" badge="1" to="/order?type=1" />
        <van-grid-item icon="tosend" text="待发货" to="/order?type=2" />
        <van-grid-item icon="logistics" text="待收货" to="/order?type=3" />
        <van-grid-item icon="comment-o" text="待评价" to="/order?type=4" />
        <van-grid-item icon="refund-o" text="退款/售后" to="/refund" />
      </van-grid>
    </van-cell-group>

    <van-cell-group inset class="menu-group">
      <van-cell title="商品收藏" icon="star-o" is-link to="/collection" v-if="userStore.isLogin" />
      <van-cell title="浏览历史" icon="clock-o" is-link to="/history" />
      <van-cell title="收货地址" icon="location-o" is-link to="/address" v-if="userStore.isLogin" />
      <van-cell title="官方客服" icon="service-o" is-link @click="showService" />
      <van-cell title="设置" icon="setting-o" is-link to="/settings" />
    </van-cell-group>

    <!-- 移除了这里的退出登录按钮，统一放到设置页面 -->
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router';
import { useUserStore } from '../store/user';
import { showDialog, showToast } from 'vant';
import 'vant/es/dialog/style';
import 'vant/es/toast/style';

const router = useRouter();
const userStore = useUserStore();

const handleLogin = () => {
  if (!userStore.isLogin) {
    router.push('/login');
  }
};

const showService = () => {
    // 未登录也可以联系客服，但建议登录
    if (!userStore.isLogin) {
        showDialog({
            title: '提示',
            message: '建议登录后联系客服，是否去登录？',
            showCancelButton: true
        }).then((action) => {
            if (action === 'confirm') {
                router.push('/login');
            } else {
                // 不登录也可以去
                router.push('/message/chat/1');
            }
        });
    } else {
        router.push('/message/chat/1');
    }
};
</script>

<style lang="less" scoped>
.profile-page {
  min-height: 100vh;
  background-color: #f7f8fa;
  padding-bottom: 20px;
}
.user-header {
  background: linear-gradient(to right, #39a9ed, #5ec2f8);
  padding: 30px 20px 50px; // 底部留白给钱包卡片重叠
  color: #fff;
  
  .user-header-content {
    display: flex;
    align-items: center;
  }
  
  .avatar {
    border: 2px solid rgba(255,255,255,0.5);
  }

  .user-info {
    margin-left: 15px;
    flex: 1;
    
    .username {
      font-size: 20px;
      font-weight: bold;
      margin-bottom: 5px;
    }
    .user-id, .user-tips {
      font-size: 13px;
      opacity: 0.9;
    }
  }
  
  .arrow-icon {
    font-size: 16px;
    opacity: 0.8;
  }
}

.wallet-group {
  margin-top: -30px; // 向上重叠
  margin-bottom: 15px;
  position: relative;
  z-index: 1;
  
  .wallet-num {
    font-size: 18px;
    font-weight: bold;
    color: #333;
    margin-bottom: 5px;
  }
  .wallet-text {
    font-size: 12px;
    color: #666;
  }
}

.order-group {
  margin-bottom: 15px;
}
.menu-group {
  margin-bottom: 20px;
}
.logout-btn {
  padding: 0 16px;
}
</style>
