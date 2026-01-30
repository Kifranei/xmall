<template>
  <div class="order-detail">
    <van-nav-bar
      title="订单详情"
      left-arrow
      @click-left="onClickLeft"
      fixed
      placeholder
    />

    <!-- 状态栏 -->
    <div class="status-card">
        <div class="status-text">{{ getStatusText(order.status) }}</div>
        <div class="status-desc">
            <span v-if="order.status === 0">剩余23小时59分自动关闭</span>
            <span v-if="order.status === 1">商家正在打包中</span>
            <span v-if="order.status === 2">您的包裹正在运输途中</span>
            <span v-if="order.status === 3">感谢您的信任，期待再次光临</span>
            <span v-if="order.status === 4">订单已取消/退款完成</span>
        </div>
    </div>

    <!-- 地址信息 -->
    <div class="address-card" v-if="address">
        <van-icon name="location-o" class="location-icon" />
        <div class="address-info">
            <div class="user-line">
                <span class="name">{{ address.name }}</span>
                <span class="tel">{{ address.tel }}</span>
            </div>
            <div class="address-line">{{ address.province }}{{ address.city }}{{ address.county }} {{ address.addressDetail }}</div>
        </div>
    </div>

    <!-- 商品列表 -->
    <div class="goods-group">
        <div class="goods-item" v-for="item in order.items" :key="item.id" @click="goProduct(item.product_id)">
            <van-card
              :num="item.quantity"
              :price="item.price"
              :title="item.product_name"
              :thumb="item.product_image"
            />
        </div>
    </div>

    <!-- 订单信息 -->
    <van-cell-group class="info-group">
        <van-cell title="订单编号" :value="order.order_no" />
        <van-cell title="下单时间" :value="formatTime(order.created_at)" />
        <van-cell title="支付方式" value="在线支付" />
        <van-cell title="实付金额" :value="`¥ ${order.total_amount}`" class="total-cell" />
    </van-cell-group>

    <!-- 底部操作栏 -->
    <div class="footer-bar" v-if="order.status !== 4">
        <van-button round size="small" v-if="order.status === 0">去支付</van-button>
        <van-button round size="small" v-if="order.status === 1">催发货</van-button>
        <van-button round size="small" v-if="order.status === 2">查看物流</van-button>
        <van-button round size="small" v-if="order.status === 2">确认收货</van-button>
        <van-button round size="small" v-if="order.status === 3" type="primary" plain @click="showToast('评价功能开发中')">去评价</van-button>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import request from '../../utils/request';
import { showToast } from 'vant';
import 'vant/es/toast/style'; 

const route = useRoute();
const router = useRouter();

const order = ref({});
// 地址快照暂时没存那么细，这里先模拟解析或者用假数据兜底，实际应解析 order.address_snapshot
const address = ref({
    name: '张三',
    tel: '138****0000',
    province: '浙江省',
    city: '杭州市',
    county: '西湖区',
    addressDetail: '文三路 123 号'
});

onMounted(async () => {
    try {
        const res = await request.get(`/orders/${route.params.id}`);
        order.value = res;
        // 如果后端存了 JSON 格式的地址快照，可以在这里解析
        // if (res.address_snapshot) {
        //     address.value = JSON.parse(res.address_snapshot);
        // }
    } catch (error) {
        showToast('加载失败');
    }
});

const onClickLeft = () => router.back();

const goProduct = (id) => {
    router.push(`/product/${id}`);
};

const getStatusText = (status) => {
    const map = {
        0: '待付款',
        1: '待发货',
        2: '待收货',
        3: '交易成功',
        4: '交易关闭'
    };
    return map[status] || '';
};

const formatTime = (timeStr) => {
    if (!timeStr) return '';
    const date = new Date(timeStr);
    return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')} ${String(date.getHours()).padStart(2, '0')}:${String(date.getMinutes()).padStart(2, '0')}`;
};
</script>

<style lang="less" scoped>
.order-detail {
  min-height: 100vh;
  background-color: #f7f8fa;
  padding-bottom: 60px;
}

.status-card {
    background: linear-gradient(to right, #ff6034, #ee0a24);
    padding: 20px;
    color: #fff;
    
    .status-text {
        font-size: 18px;
        font-weight: bold;
        margin-bottom: 5px;
    }
    .status-desc {
        font-size: 12px;
        opacity: 0.9;
    }
}

.address-card {
    background: #fff;
    padding: 15px;
    display: flex;
    align-items: center;
    margin-bottom: 10px;
    
    .location-icon {
        font-size: 20px;
        color: #666;
        margin-right: 10px;
    }
    
    .address-info {
        flex: 1;
        .user-line {
            font-size: 14px;
            font-weight: bold;
            margin-bottom: 5px;
            .tel {
                margin-left: 10px;
                color: #666;
                font-weight: normal;
            }
        }
        .address-line {
            font-size: 12px;
            color: #666;
            line-height: 1.4;
        }
    }
}

.goods-group {
    background: #fff;
    margin-bottom: 10px;
    padding: 10px 0;
}

.info-group {
    margin-bottom: 10px;
    .total-cell {
        :deep(.van-cell__value) {
            color: #ee0a24;
            font-weight: bold;
        }
    }
}

.footer-bar {
    position: fixed;
    bottom: 0;
    left: 0;
    right: 0;
    background: #fff;
    padding: 10px 15px;
    display: flex;
    justify-content: flex-end;
    box-shadow: 0 -2px 10px rgba(0,0,0,0.05);
    
    .van-button {
        margin-left: 10px;
    }
}
</style>