# 自定义事件

````
//自定义事件aaa
const emit = defineEmits(['aaa'])
//调用事件
emit('aaa', '参数')


//特殊事件,更新v-model
const emit = defineEmits(['update:modelValue'])
emit('update:modelValue', res)

````

