import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/Home.vue'
import Search from '../views/Search.vue'
import Cart from '../views/Cart.vue'
import Profile from '../views/Profile.vue'
import ProductDetail from '../views/ProductDetail.vue'
import AddressList from '../views/address/AddressList.vue'
import AddressEdit from '../views/address/AddressEdit.vue'
import OrderList from '../views/order/OrderList.vue'
import RefundList from '../views/order/RefundList.vue'
import OrderDetail from '../views/order/OrderDetail.vue'
import Settings from '../views/user/Settings.vue'
import UserProfile from '../views/user/UserProfile.vue'
import CommonList from '../views/user/CommonList.vue'
import SearchResult from '../views/SearchResult.vue'
import MessageList from '../views/message/MessageList.vue'
import Chat from '../views/message/Chat.vue'
import Login from '../views/login/Login.vue'
import Register from '../views/login/Register.vue'
import ForgotPassword from '../views/login/ForgotPassword.vue'
import AccountSecurity from '../views/user/security/AccountSecurity.vue'
import ChangeMobile from '../views/user/security/ChangeMobile.vue'
import ChangePassword from '../views/user/security/ChangePassword.vue'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: Login,
    meta: { title: '登录' }
  },
  {
    path: '/register',
    name: 'Register',
    component: Register,
    meta: { title: '注册' }
  },
  {
    path: '/forgot-password',
    name: 'ForgotPassword',
    component: ForgotPassword,
    meta: { title: '找回密码' }
  },
  {
    path: '/settings/security',
    name: 'AccountSecurity',
    component: AccountSecurity,
    meta: { title: '账号与安全' }
  },
  {
    path: '/user/change-mobile',
    name: 'ChangeMobile',
    component: ChangeMobile,
    meta: { title: '修改手机号' }
  },
  {
    path: '/user/change-password',
    name: 'ChangePassword',
    component: ChangePassword,
    meta: { title: '修改密码' }
  },
  {
    path: '/search-result',
    name: 'SearchResult',
    component: SearchResult,
    meta: { title: '搜索结果' }
  },
  {
    path: '/message',
    name: 'MessageList',
    component: MessageList,
    meta: { showTabbar: true, title: '消息' }
  },
  {
    path: '/message/chat/:id',
    name: 'Chat',
    component: Chat,
    meta: { title: '聊天' }
  },
  {
    path: '/order/:id',
    name: 'OrderDetail',
    component: OrderDetail,
    meta: { title: '订单详情' }
  },
  {
    path: '/settings/profile',
    name: 'UserProfile',
    component: UserProfile,
    meta: { title: '个人资料' }
  },
  {
    path: '/',
    name: 'Home',
    component: Home,
    meta: { showTabbar: true, title: '首页' }
  },
  {
    path: '/search',
    name: 'Search',
    component: Search,
    meta: { showTabbar: true, title: '分类' }
  },
  {
    path: '/cart',
    name: 'Cart',
    component: Cart,
    meta: { showTabbar: true, title: '购物车' }
  },
  {
    path: '/profile',
    name: 'Profile',
    component: Profile,
    meta: { showTabbar: true, title: '个人中心' }
  },
  {
    path: '/product/:id',
    name: 'ProductDetail',
    component: ProductDetail,
    meta: { showTabbar: false, title: '商品详情' }
  },
  {
    path: '/address',
    name: 'AddressList',
    component: AddressList,
    meta: { title: '收货地址' }
  },
  {
    path: '/address/edit',
    name: 'AddressEdit',
    component: AddressEdit,
    meta: { title: '编辑地址' }
  },
  {
    path: '/order',
    name: 'OrderList',
    component: OrderList,
    meta: { title: '我的订单' }
  },
  {
    path: '/refund',
    name: 'RefundList',
    component: RefundList,
    meta: { title: '退款/售后' }
  },
  {
    path: '/settings',
    name: 'Settings',
    component: Settings,
    meta: { title: '设置' }
  },
  {
    path: '/collection',
    name: 'Collection',
    component: CommonList,
    meta: { title: '商品收藏' }
  },
  {
    path: '/history',
    name: 'History',
    component: CommonList,
    meta: { title: '浏览历史' }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
