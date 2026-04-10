<template>
  <div class="container">
    <h1>Hello world from Debian Server 🚀</h1>
    <button @click="fetchHello" :disabled="loading" class="btn">
      {{ loading ? 'Cargando...' : 'Traer mensaje del servidor' }}
    </button>
    <div v-if="message" class="message">
      {{ message }}
    </div>
    <div v-if="error" class="error">
      ⚠️ {{ error }}
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';

const message = ref('');
const loading = ref(false);
const error = ref('');

const fetchHello = async () => {
  loading.value = true;
  error.value = '';
  message.value = '';

  try {
    // Usamos import.meta.env para leer variables de entorno en Vite
    const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:8080';
    const response = await fetch(`${apiUrl}/hello`);
    if (!response.ok) {
      throw new Error(`Error del servidor: ${response.status}`);
    }
    const text = await response.text();
    message.value = text;
  } catch (err) {
    console.error('Error al traer el mensaje:', err);

    if (err.message.includes('Failed to fetch')) {
      error.value = 'No se puede conectar al servidor. ¿Está corriendo en http://localhost:8080?';
    } else {
      error.value = err.message || 'Error desconocido';
    }
  } finally {
    loading.value = false;
  }
};
</script>

<style scoped>
.container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 2rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 15px;
  min-height: 300px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
}

h1 {
  color: white;
  font-size: 2rem;
  margin-bottom: 2rem;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
}

.btn {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  color: white;
  border: none;
  padding: 12px 30px;
  font-size: 1rem;
  font-weight: bold;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 4px 15px rgba(245, 87, 108, 0.4);
  margin-bottom: 1.5rem;
}

.btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(245, 87, 108, 0.6);
}

.btn:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}

.message {
  background: white;
  color: #333;
  padding: 1.5rem 2rem;
  border-radius: 8px;
  margin-top: 1rem;
  font-size: 1.2rem;
  font-weight: bold;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  animation: slideIn 0.3s ease;
}

.error {
  background: #ff6b6b;
  color: white;
  padding: 1rem 1.5rem;
  border-radius: 8px;
  margin-top: 1rem;
  font-weight: bold;
  box-shadow: 0 4px 15px rgba(255, 107, 107, 0.4);
}

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>