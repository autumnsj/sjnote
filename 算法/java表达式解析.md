```java
import java.math.BigDecimal;
import java.util.*;
import java.util.function.Function;

public class ExpUtils {
    //分割提取操作表达式元素
    private static final String allOps = ",=≠≥≤+-×÷*/()或且\"";
    private static final String boolOps = "=≠≥≤或且";
    private static final String numericOps = "+-×÷*/";
    private static final String calcOps = "=≠≥≤或且+-×÷*/";
    //根据数据获取获得娄据数据参数的方法
    public static Function<String,Object> getFunction(String objJson){
        String [] aaaa = objJson.split(",");
        //套娃
        return (name)->{
            switch (name){
                case "实重":
                    return new BigDecimal(aaaa[0]);
                case "名包含": {
                    Function<String, Boolean> f = (s) -> {
                        return s.contains(s);
                    };
                    return f;
                }
                case "小时":{
                    Function<Void,BigDecimal> f= (s)->{
                        return  new BigDecimal(aaaa[1]);
                       // return new BigDecimal(LocalTime.now().getHour());
                    };
                    return  f;
                }
                case "add":{
                    Function<Object[],BigDecimal> f= (s)->{
                        return ((BigDecimal)s[0]).add(((BigDecimal)s[1]));
                    };
                    return f;
                }
            }
            throw new Exception("无效参数");
        };
    }
    public static void main(String[] args) {
        //exec("实重 * add(0.5,1.5)+(小时()-10)",getFunction("9,12,广西la"),Number.class);
        //exec("实重 * add(0.5,1.5)+(小时()-10)",getFunction("10,2,深圳abc"),Number.class);
        exec("实重≤12",getFunction("13,2,深圳abc"),Boolean.class);
        exec("13",getFunction("13,2,深圳abc"),Boolean.class);
    }
    private static int getPriority(char op){
       if(op=='+' || op=='-'){
           return 3;
       }
       else if(op == '×'|| op =='÷'||op == '*'|| op =='/' ){
          return 2;
       }
       else if(boolOps.contains(String.valueOf(op))){
           //布尔运算优先级最低
           return 4;
       }
       return 0;
    }
    //计算表达式
    public static <T> T exec(String exp, Function<String,Object> getMethod, Class<T> clazz) {
        exp = exp.trim();
        Stack<Object> values = new Stack<>();
        Stack<Character> ops = new Stack<>();
        StringBuffer valueBuffer = new StringBuffer();
        List<String> exp_items = new ArrayList<>();
        Stack<Object> funcParams=new Stack<>();
        //开始识别表达式
        char[] expCharArr = exp.toCharArray();
        for (int i = 0; i < expCharArr.length;i++)
        {
            char item =  expCharArr[i];
            //如果上一个操作符是", 而且当前不是", 则当前是字符串参数,
            if(!ops.isEmpty()&&ops.peek()=='"'&&item!='"'){
                valueBuffer.append(item);
                continue;
            }
            //如果不是操作符
            if(!isOperator(String.valueOf(item)))
            {
                //空格
                if(item!=' ') {
                    valueBuffer.append(item);
                }
                if(i != expCharArr.length-1){
                   //如果不是最后一个
                    continue;
                }
            }
            if(!valueBuffer.isEmpty()){ //如果参数buffer不为空, 就先把参数压栈
                if(isNumeric(valueBuffer.toString())){
                    //如果是数字就压数字
                    values.push(new BigDecimal(valueBuffer.toString()));
                }else{
                    //非数字 要么是变量, 函数, 或者字符串
                    if(item == '"'){
                        //如果是引号, 则证明是字符串
                        values.push(valueBuffer.toString());
                    }else{
                        //不是字符串就是变量, 变量就从参数params取, 有可能是变量或者函数
                        Object temp = getMethod.apply(valueBuffer.toString());
                        if(temp == null){
                            throw new Exception(String.format("表达式:%s ,无效标识符:%s",exp,valueBuffer.toString()));
                        }
                        values.push(temp);
                    }
                }
                exp_items.add(valueBuffer.toString()); //记录表达式
                valueBuffer.setLength(0);
            }
            if(!isOperator(String.valueOf(item))){
               continue;
            }
            exp_items.add(String.valueOf(item));//记录表达式
            /** 执行到这说明当前为操作符,或者是最后一个**/
            //如果运算符栈为空
            if(ops.isEmpty()){
                ops.push(item);
                continue;
            }
            //如果是计算符运算符
            if(isCalcOperator(String.valueOf(item))){
                //如果上一个不是运算符
                if(!isCalcOperator(String.valueOf(ops.peek()))){
                    ops.push(item);
                    continue;
                }
                //如果栈顶也是运算符则判断优先级, 如果当前优先级大于栈顶优先级则不计算
                if(getPriority(item) < getPriority(ops.peek())){
                    //如果当前优先级大于栈顶优先级则直接压栈,先不计算
                    ops.push(item);
                    continue;
                }
                //如果栈顶优先级大于当前优先级, 则对栈顶运算符进行运算,运算结果存回栈顶
                Object val2 = values.pop();
                Object val1 = values.pop();
                Object temp = singleCalc(String.valueOf(ops.pop()), val1, val2);
                values.push(temp);
                ops.push(item);

            }else{
                //如果不是计算符
                if(item =='"'){
                    //如果是双引号
                    if(ops.peek()=='"'){
                        ops.pop();
                    }else{
                        ops.push(item);
                    }
                }else if(item == '('){
                    //如果遇到左括号, 要检查上一个是不是操作符,如果是操作符则说明此扩号是优先级括号, 如果不是操作符则说明这个是函数括号,如果是函数插号要做处理
                    if(!isOperator(exp_items.get(exp_items.size()-2))){
                        ops.push('f');
                    }
                    ops.push(item);
                }else if(item == ','){
                    ops.push(item);
                }
                else if(item ==')') {
                   //就要计算直到遇到左括号或者是最后一个 就要开始计算
                   while (!ops.isEmpty()&&ops.peek() != '('){
                       Character op = ops.pop();
                       if(isCalcOperator(String.valueOf(op))){
                           //如果是计算操作符就计算
                           Object val2 = values.pop();
                           Object val1 = values.pop();
                           Object temp = singleCalc(String.valueOf(op), val1, val2);
                           values.push(temp);
                       }else if(op ==','){
                           //如果是逗号就忽略,说明是函数参数
                           funcParams.push(values.pop());
                       }
                   }
                   //如果为空, 则说明上一个循环while,没有遇到左扩号(
                   if(ops.isEmpty()){
                      throw new Exception("表达式缺少左括号(");
                   }
                   //能走到这里说明遇到了左括号
                   ops.pop();//弹出左括号
                   if(!ops.isEmpty()&&ops.peek() == 'f'){
                       ops.pop();//弹出f 并对函数进行调用
                       //根据上一个是不是左括号, 判断函数是否有参数, 如果是则函数无参,否则有参
                       if(exp_items.size()>=2&&!exp_items.get(exp_items.size()-2).equals("(")){
                          //函数有参, 将参数弹出
                          funcParams.push(values.pop());
                       }
                       //如果栈顶是f, 说明是函数调用
                       Object tempFunc= values.pop();
                       //调用函数
                       Function func = (Function)tempFunc;
                       //调用函数
                       Object fRes=func.apply(funcParams.size()==0?null:funcParams.stream().toArray());
                       values.push(fRes);
                       funcParams.clear();
                   }
                }
            }
        }
        while (ops.size()>0){
            Object val2 = values.pop();
            Object val1 = values.pop();
            Object temp = singleCalc(String.valueOf(ops.pop()), val1, val2);
            values.push(temp);
        }
        if(values.size()>1){
            throw new Exception("表达式有误:"+exp);
        }
        T res =  (T)values.pop();
        System.out.println("表达式:"+ exp);
        System.out.println("表达式解析结果:"+ exp_items.toString());
        System.out.println("计算结果:"+ res);
        return res;
    }
    public static Object singleCalc(String op,Object val1,Object val2){
        if(!val1.getClass().equals(val2.getClass()))
        {
           throw new Exception(String.format("运算符%s无法对不同类型的参数进行运算",op));
        }
        switch (op){
            case "+":
                return ((BigDecimal)val1).add((BigDecimal)val2);
            case "-":
                return ((BigDecimal)val1).subtract((BigDecimal)val2);
            case "×":
            case "*":
                return ((BigDecimal)val1).multiply((BigDecimal)val2);
            case "÷":
            case "/":
                return ((BigDecimal)val1).divide((BigDecimal)val2);

        }
        switch(op){
            case "=":
                if(val1 instanceof Boolean){
                   return (Boolean)val1 == (Boolean)val2;
                }
                else if(val1 instanceof BigDecimal){
                   return  ((BigDecimal)val1).equals((BigDecimal)val2);
                }
            case "≠":
                if(val1 instanceof Boolean){
                    return (Boolean)val1 != (Boolean)val2;
                }
                else if(val1 instanceof BigDecimal){
                    return  !((BigDecimal)val1).equals((BigDecimal)val2);
                }
            case "≥":
                 return ((BigDecimal)val1).compareTo((BigDecimal)val2)>=0;
            case "≤":
                return ((BigDecimal)val1).compareTo((BigDecimal)val2)<=0;
        }
        throw new Exception(String.format("运算符%s无法对参数(%s,%s)进行运算",op,val1,val2));
    }

    /**
     * 判断是不是操作符
     * @param str
     * @return	
     */
    public static Boolean isOperator(String str){
       return allOps.contains(str);
    }
    //布尔操作符
    public static Boolean isBoolOperator(String str){
        return boolOps.contains(str);
    }
    /**
     * 是计算操作符
     * @param str
     * @return
     */
    public static Boolean isCalcOperator(String str){
        return calcOps.contains(str);
    }

    public static Boolean isNumeric(String str) {
        try {
            Double.parseDouble(str); // 尝试将字符串转换为 double
            return true; // 能成功转换，说明是数字
        } catch (NumberFormatException e) {
            return false; // 转换失败，不是数字
        }
    }
}
```