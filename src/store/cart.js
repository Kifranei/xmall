import { defineStore } from 'pinia';
import { ref, computed } from 'vue';

export const useCartStore = defineStore('cart', () => {
  const cartList = ref([]);

  const addToCart = (product) => {
    const existing = cartList.value.find(item => item.id === product.id);
    if (existing) {
      existing.count++;
    } else {
      cartList.value.push({ ...product, count: 1, checked: true });
    }
  };
  
  const removeFromCart = (id) => {
      const index = cartList.value.findIndex(item => item.id === id);
      if(index > -1) {
          cartList.value.splice(index, 1);
      }
  }

  const clearCart = () => {
      cartList.value = [];
  }

  const totalCount = computed(() => {
    return cartList.value.reduce((sum, item) => sum + item.count, 0);
  });
  
  const totalPrice = computed(() => {
      return cartList.value
        .filter(item => item.checked)
        .reduce((sum, item) => sum + item.count * parseFloat(item.price), 0) * 100; // Vant SubmitBar price is in cents
  })

  return { cartList, addToCart, removeFromCart, clearCart, totalCount, totalPrice };
});
