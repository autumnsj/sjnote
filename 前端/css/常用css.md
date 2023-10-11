- css过渡效果

  ```css
  /*应用于宽度属性的过渡效果，时长为 2 秒：    */
  transition: width 2s;
  -webkit-transition: width 2s; /* Safari */
  
  /*应用于全部属性的过渡效果，时长为 2 秒：    */
  transition: all 2s;
  -webkit-transition: all 2s; /* Safari */
  
  /*应用于多属性的过渡效果，时长为 2 秒：    */
  transition: width 2s, height 2s, transform 2s;
  -webkit-transition: width 2s, height 2s, -webkit-transform 2s;
  
  ```
  
- css动画

  ```css
  /*定义关键帧*/
  @keyframes aaa{
      from{
          /*样式*/
      }
      to {
           /*样式*/
      }
  }
  @keyframes bbb{
      0%{
          /*样式*/
      }
      20% {
           /*样式*/
      }
      100%{
           /*样式*/
      }
  }
  @keyframes aaa{
      to {
           /*样式*/
      }
  }
  /*使用动画*/
  div {
      animation-name: aaa;  /*单个动画*/
      animation-name: aaa,bbb,ccc;    /*多个动画*/
      animation-fill-mode: forwards;  /*样式停留在最后一帧*/
      animation-duration: 1s;     /*动画时长*/
      animation-duration: 1s,2s,2s;        /*多个动画时长*/
      animation-delay: 2s;    /*动画延迟播放*/
  }
  
  ```


- 在CSS中,可以通过 :empty 选择器来根据元素是否包含文本内容来切换样式。示例:HTML:

  ```
  html
  <div class="message">
    <p>This is a message.</p>
  </div>
  
  <div class="message">
    <p></p>  
  </div>
  ```

  CSS:

  ```
  css
  .message p {
    color: grey; 
  }
  
  .message p:empty {
    background: #eee;
    height: 40px;
    width: 200px; 
  }
  ```

  当p标签没有文字内容时,会应用 :empty 选择器的样式,背景色变灰,同时设置了宽高。当p标签有文字时,会应用默认的灰色文字样式。这样就可以根据文字是否为空来显示不同效果。另外,也可以配合 JavaScript来切换元素的 class,根据 class 控制样式。总之,利用:empty 选择器和 class 的切换可以轻松实现根据文字是否存在来改变样式的效果

- 在 CSS 中,可以通过 :focus 选择器来根据元素是否获得焦点来切换样式。具体实现方法:HTML:

  ```
  html
  <input type="text">
  
  <button>Submit</button>
  ```

  CSS:

  ```
  css
  input {
    padding: 5px;
    border: 1px solid #ccc;
  }
  
  input:focus {
    border: 1px solid blue;
    outline: none;
  }
  
  button {
    background: #eee; 
  }
  
  button:focus {
    background: blue;
    color: #fff;
  }
  ```

  当input获得焦点时,会应用input:focus的样式,边框变蓝色。当button获得焦点时,会应用button:focus的样式,背景变蓝色、文字变白色。另外也可以结合 JavaScript,在focus和blur事件中添加或删除类,实现样式切换。利用 :focus选择器,可以非常方便地根据元素焦点状态来切换样式,提供更好的用户体验

- 对于子节点获得焦点时切换父元素样式,可以通过 CSS 的 :focus-within 选择器实现:HTML:

  ```
  html
  <div class="parent">
    <input type="text"> 
  </div>
  ```

  CSS:

  ```
  css
  .parent {
    padding: 10px;
    border: 1px solid #ccc; 
  }
  
  .parent:focus-within {
    border: 1px solid blue;
    background: #f2f2f2;
  }
  ```

  

- 如果要在子节点有指定样式时切换父节点的样式,可以通过 CSS 的 :has() 选择器实现:HTML:
  ```
  html
  <div class="parent">
    <p class="highlighted">This is a paragraph.</p>
  </div>
  ```

  CSS:

  ```
  css
  .parent {
    border: 1px solid #ccc;
  }
  
  .parent:has(.highlighted) {
    border-color: blue;
  }
  ```

  当子元素 p 有 .highlighted 类时,:has() 会匹配到父元素 .parent,并应用指定的 border-color。
