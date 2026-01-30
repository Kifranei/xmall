<template>
  <div class="search-page">
    <van-sticky>
      <van-search
        v-model="searchValue"
        show-action
        shape="round"
        placeholder="请输入搜索关键词"
        @search="onSearch"
      >
        <template #action>
          <div @click="onSearch">搜索</div>
        </template>
      </van-search>
    </van-sticky>

    <div class="category-container">
      <van-sidebar v-model="activeCategory" class="sidebar">
        <van-sidebar-item 
            v-for="(item, index) in categories" 
            :key="item.id" 
            :title="item.name" 
            @click="onCategoryClick(index)"
        />
      </van-sidebar>
      
      <div class="category-content">
        <div class="category-title">{{ categories[activeCategory]?.name }}</div>
        <van-grid :column-num="3" :border="false">
          <van-grid-item v-for="sub in subCategories" :key="sub.name" @click="goSearch(sub.name)">
            <van-image :src="sub.img" width="100%" height="60" fit="contain" />
            <div class="sub-name">{{ sub.name }}</div>
          </van-grid-item>
        </van-grid>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import request from '../utils/request';

const router = useRouter();
const searchValue = ref('');
const activeCategory = ref(0);
const categories = ref([]);
const subCategories = ref([]);

// 获取分类数据
const fetchCategories = async () => {
  try {
    const res = await request.get('/categories');
    categories.value = res;
    // 默认加载第一个分类的子类
    if (categories.value.length > 0) {
      fetchSubCategories(categories.value[0].id);
    }
  } catch (error) {
    console.error(error);
  }
};

// 获取子分类
const fetchSubCategories = async (parentId) => {
  try {
    const res = await request.get('/categories/sub', { params: { parentId } });
    subCategories.value = res.map(item => ({
        ...item,
        img: item.icon
    }));
  } catch (error) {
    console.error(error);
  }
};

// 监听左侧点击
const onCategoryClick = (index) => {
    activeCategory.value = index;
    const category = categories.value[index];
    if(category) {
        fetchSubCategories(category.id);
    }
};

onMounted(() => {
  fetchCategories();
});

const onSearch = () => {
  if (searchValue.value) {
    router.push({
      path: '/search-result', // 修改为跳转到搜索结果页
      query: { q: searchValue.value }
    });
  }
};

const goSearch = (name) => {
  searchValue.value = name;
  onSearch();
};
</script>

<style lang="less" scoped>
.search-page {
  height: 100vh;
  display: flex;
  flex-direction: column;
}
.category-container {
  flex: 1;
  display: flex;
  overflow: hidden;
}
.sidebar {
  overflow-y: auto;
  background-color: #f7f8fa;
  width: 85px;
}
.category-content {
  flex: 1;
  overflow-y: auto;
  background-color: #fff;
  padding: 10px;
}
.category-title {
  font-weight: bold;
  padding: 10px 0;
  font-size: 14px;
}
.sub-name {
  margin-top: 5px;
  font-size: 12px;
  color: #333;
}
</style>
