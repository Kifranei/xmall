import { createApp } from 'vue'
import { createPinia } from 'pinia'
import './style.css'
import App from './App.vue'
import router from './router'

// 引入 Vant 全局样式 (可选，如果按需引入配置不完全可以兜底)
import 'vant/lib/index.css';

const app = createApp(App)

app.use(createPinia())
app.use(router)

app.mount('#app')
