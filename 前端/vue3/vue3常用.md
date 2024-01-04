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

## Vue数据监听器watch和watchEffect的使用

### watch()函数

watch 需要侦听特定的数据源，比如侦听一个 ref，watch 的第一个参数可以是不同形式的“数据源”：它可以是一个 ref (包括计算属性)、一个响应式对象、一个 getter 函数、或多个数据源组成的数组，如下：

```typescript
const x = ref(0)
const y = ref(0)
// 单个 ref
watch(x, (newX) => {
  console.log(`x is ${newX}`)
})
// getter 函数
watch(
  () => x.value + y.value,
  (sum) => {
    console.log(`sum of x + y is: ${sum}`)
  }
)
// 多个来源组成的数组
watch([x, () => y.value], ([newX, newY]) => {
  console.log(`x is ${newX} and y is ${newY}`)
})
const obj = reactive({ count: 0 })
//传入一个响应式对象
watch(obj, (newValue, oldValue) => {
  // 在嵌套的属性变更时触发
  // 注意：`newValue` 此处和 `oldValue` 是相等的
  // 因为它们是同一个对象！
})
obj.count++
watch(
  () => obj.count,
  (newValue, oldValue) => {
    // 注意：`newValue` 此处和 `oldValue` 是相等的
    // *除非* obj.count 被整个替换了
  },
  { deep: true }
)

```

注意，你不能直接侦听响应式对象的属性值

```typescript
const obj = reactive({ count: 0 })
// 错误，因为 watch() 得到的参数是一个 number
watch(obj.count, (count) => {
  console.log(`count is: ${count}`)
})

```

这里需要用一个返回该属性的 getter 函数：

```typescript
// 提供一个 getter 函数
watch(
  () => obj.count,
  (count) => {
    console.log(`count is: ${count}`)
  }
)

```

watch 默认是懒执行的：仅当数据源变化时，才会执行回调。但在某些场景中，我们希望在创建监听器时，立即执行一遍回调。举例来说，我们想请求一些初始数据，然后在相关状态更改时重新请求数据。

我们可以通过传入 immediate: true 选项来强制监听器的回调立即执行：

```typescript
watch(source, (newValue, oldValue) => {
  // 立即执行，且当 `source` 改变时再次执行
}, { immediate: true })

```

## watchEffect()函数

watchEffect() 允许我们自动跟踪回调的响应式依赖。

```typescript
const todoId = ref(1)
const data = ref(null)
watchEffect(async () => {
  const response = await fetch(
    `https://jsonplaceholder.typicode.com/todos/${todoId.value}`
  )
  data.value = await response.json()
})

```

这个例子中，回调会立即执行，不需要指定 immediate: true。在执行期间，它会自动追踪 todoId.value 作为依赖（和计算属性类似）。每当 todoId.value 变化时，回调会再次执行。有了 watchEffect()，我们不再需要明确传递 todoId 作为源值。

watchEffect() 适合有多个依赖项的监听器对于这种只有一个依赖项的例子来说，好处相对较小。此外，如果你需要侦听一个嵌套数据结构中的几个属性，watchEffect() 可能会比深度监听器更有效，因为它将只跟踪回调中被使用到的属性，而不是递归地跟踪所有的属性。

如果想在监听器回调中能访问被 Vue 更新之后的 DOM，你需要指明 flush: ‘post’ 选项，

后置刷新的 watchEffect() 有个更方便的别名 watchPostEffect()：

```typescript
import { watchPostEffect } from 'vue'
watchPostEffect(() => {
  /* 在 Vue 更新后执行 */
})

```

## watch与watchEffect之间的联系与区别

watch 和 watchEffect 都能响应式地执行有副作用的回调。它们之间的主要区别是追踪响应式依赖的方式：

watch 只追踪明确侦听的数据源。它不会追踪任何在回调中访问到的东西。另外，仅在数据源确实改变时才会触发回调。watch 会避免在发生副作用时追踪依赖，因此，我们能更加精确地控制回调函数的触发时机。

watchEffect，则会在副作用发生期间追踪依赖。它会在同步执行过程中，自动追踪所有能访问到的响应式属性。这更方便，而且代码往往更简洁，但有时其响应性依赖关系会不那么明确。适合有多个依赖项的监听器