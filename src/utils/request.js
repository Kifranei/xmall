import axios from 'axios';
import { showToast } from 'vant';

const service = axios.create({
  baseURL: '/api', // 使用代理
  timeout: 5000
});

// 请求拦截器
service.interceptors.request.use(
  config => {
    return config;
  },
  error => {
    console.log(error);
    return Promise.reject(error);
  }
);

// 响应拦截器
service.interceptors.response.use(
  response => {
    const res = response.data;
    if (res.code !== 0) {
      showToast(res.message || 'Error');
      return Promise.reject(new Error(res.message || 'Error'));
    } else {
      return res.data;
    }
  },
  error => {
    console.log('err' + error);
    showToast(error.message);
    return Promise.reject(error);
  }
);

export default service;
