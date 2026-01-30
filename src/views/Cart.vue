<template>
  <div class="cart-page">
    <van-nav-bar 
      title="购物车" 
      :right-text="cartList.length > 0 ? '清空' : ''"
      @click-right="handleClear"
      fixed 
      placeholder 
    />
    
    <div class="cart-list" v-if="cartList.length > 0">
      <van-checkbox-group v-model="checkedResult" @change="onCheckChange">
        <div v-for="item in cartStore.cartList" :key="item.id" class="cart-item">
           <van-checkbox :name="item.id" class="check-box" />
           <van-card
             :num="item.count"
             :price="item.price"
             :title="item.name"
             :thumb="item.img"
           >
             <template #footer>
               <van-stepper v-model="item.count" theme="round" button-size="22" disable-input />
               <van-button size="mini" type="danger" @click="removeItem(item.id)" style="margin-left: 10px;">删除</van-button>
             </template>
           </van-card>
        </div>
      </van-checkbox-group>
      
      <van-submit-bar
        :price="cartStore.totalPrice"
        button-text="提交订单"
        @submit="onSubmit"
        style="bottom: 50px;" 
      >
        <van-checkbox v-model="checkedAll" @click="toggleAll">全选</van-checkbox>
      </van-submit-bar>
    </div>
    
    <van-empty v-else description="购物车空空如也" />
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue';
import { useCartStore } from '../store/cart';
import { showToast, showDialog } from 'vant';
import 'vant/es/dialog/style';
import 'vant/es/toast/style';

const cartStore = useCartStore();
const cartList = computed(() => cartStore.cartList);
const checkedResult = ref([]);
const checkedAll = ref(false);

// 初始化选中状态
watch(() => cartStore.cartList, (list) => {
    // 保持 store 中的 checked 状态与 UI 同步 (这里简化处理，store 里的 checked 属性主要用于计算总价)
    // 实际可以通过 computed 来做双向绑定，这里手动同步
    list.forEach(item => {
        if(item.checked && !checkedResult.value.includes(item.id)) {
            checkedResult.value.push(item.id);
        }
    })
    // 检查是否全选
    if(list.length > 0 && checkedResult.value.length === list.length) {
        checkedAll.value = true;
    } else {
        checkedAll.value = false;
    }
}, { deep: true, immediate: true });

const onCheckChange = (values) => {
    cartStore.cartList.forEach(item => {
        item.checked = values.includes(item.id);
    });
    checkedAll.value = values.length === cartStore.cartList.length;
};

const toggleAll = () => {
    if (checkedAll.value) {
        checkedResult.value = cartStore.cartList.map(item => item.id);
    } else {
        checkedResult.value = [];
    }
    onCheckChange(checkedResult.value);
};

const removeItem = (id) => {
    cartStore.removeFromCart(id);
    // 更新 checkedResult
    checkedResult.value = checkedResult.value.filter(val => val !== id);
};

const onSubmit = () => {
    showToast('提交订单成功');
};

const handleClear = () => {
  showDialog({
    title: '提示',
    message: '确认清空购物车吗？',
    showCancelButton: true,
  }).then((action) => {
    if (action === 'confirm') {
      cartStore.clearCart();
      showToast('购物车已清空');
    }
  });
};
</script>

<style lang="less" scoped>
.cart-page {
  padding-bottom: 100px;
  min-height: 100vh;
  background-color: #f7f8fa;
}
.cart-item {
  background: #fff;
  margin-bottom: 10px;
  display: flex;
  align-items: center;
  padding-left: 10px;
  
  .check-box {
      margin-right: 10px;
  }
  
  .van-card {
      flex: 1;
      background: #fff;
  }
}
</style>
