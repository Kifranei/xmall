import { defineStore } from 'pinia';
import { ref } from 'vue';

export const useUserStore = defineStore('user', () => {
  const isLogin = ref(false);
  const userInfo = ref({
    nickname: '点击登录',
    avatar: 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg',
    userId: '',
    balance: 0,
    points: 0,
    coupons: 0
  });

  const login = () => {
    isLogin.value = true;
    userInfo.value = {
      nickname: 'Trae用户',
      avatar: 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg',
      userId: '88888888',
      balance: 100.00,
      points: 520,
      coupons: 3
    };
  };

  const logout = () => {
    isLogin.value = false;
    userInfo.value = {
      nickname: '点击登录',
      avatar: 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg',
      userId: '',
      balance: 0,
      points: 0,
      coupons: 0
    };
  };

  return {
    isLogin,
    userInfo,
    login,
    logout
  };
});
