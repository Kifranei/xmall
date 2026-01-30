<template>
  <div class="user-profile-page">
    <van-nav-bar
      title="个人资料"
      left-arrow
      right-text="保存"
      @click-left="onClickLeft"
      @click-right="onSave"
    />

    <van-cell-group inset class="form-group">
      <van-field label="头像" readonly>
        <template #input>
            <van-uploader v-model="fileList" :max-count="1" :after-read="afterRead" />
        </template>
      </van-field>
      <!-- 暂时只模拟文本修改头像链接，或者直接展示当前头像 -->
      <van-field 
        v-model="userInfo.avatar" 
        label="头像链接" 
        placeholder="请输入头像URL" 
        clearable
      />
      
      <van-field
        v-model="userInfo.nickname"
        label="昵称"
        placeholder="请输入昵称"
        clearable
      />
      <van-field
        v-model="userInfo.username"
        label="用户名"
        readonly
      />
      <van-field
        v-model="userInfo.userId"
        label="用户ID"
        readonly
      />
    </van-cell-group>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { useUserStore } from '../../store/user';
import request from '../../utils/request';
import { showToast } from 'vant';

const router = useRouter();
const userStore = useUserStore();

const userInfo = ref({
    nickname: '',
    avatar: '',
    username: '',
    userId: ''
});

const fileList = ref([]);

onMounted(() => {
    // 初始化数据
    userInfo.value = { ...userStore.userInfo };
    if (userStore.userInfo.avatar) {
        fileList.value = [{ url: userStore.userInfo.avatar }];
    }
});

const onClickLeft = () => router.back();

const afterRead = (file) => {
    // 这里应该上传文件到服务器，得到 URL
    // 模拟上传成功，直接用 base64 或者假装
    console.log(file);
    // 实际场景：const formData = new FormData(); formData.append('file', file.file); request.post('/upload', formData)...
    // 简单起见，这里不做真实文件上传，只保留 fileList 显示
    // 如果用户想改头像，可以直接改下面的链接输入框，或者我们这里模拟一下
    userInfo.value.avatar = file.content || 'https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg';
};

const onSave = async () => {
    try {
        const res = await request.put('/user', {
            nickname: userInfo.value.nickname,
            avatar: userInfo.value.avatar
        });
        
        // 更新 store
        userStore.setUserInfo(res);
        showToast('保存成功');
        router.back();
    } catch (error) {
        showToast('保存失败');
    }
};
</script>

<style lang="less" scoped>
.user-profile-page {
  min-height: 100vh;
  background-color: #f7f8fa;
  padding-top: 10px;
}
.form-group {
    margin-top: 10px;
}
</style>