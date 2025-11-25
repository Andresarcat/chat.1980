<script setup>
import EmptyState from 'dashboard/components/widgets/EmptyState.vue';
import { onMounted } from 'vue';

const toggleSupportWidgetVisibility = () => {
  if (window.$1080tic) {
    window.$1080tic.toggleBubbleVisibility('show');
  }
};

const setupListenerForWidgetEvent = () => {
  window.addEventListener('1080tic:on-message', () => {
    toggleSupportWidgetVisibility();
  });
};

onMounted(() => {
  toggleSupportWidgetVisibility();
  setupListenerForWidgetEvent();
});
</script>

<template>
  <div class="items-center bg-n-slate-2 flex justify-center h-full w-full">
    <EmptyState
      :title="$t('APP_GLOBAL.ACCOUNT_SUSPENDED.TITLE')"
      :message="$t('APP_GLOBAL.ACCOUNT_SUSPENDED.MESSAGE')"
    />
  </div>
</template>
