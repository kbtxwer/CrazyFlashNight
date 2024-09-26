﻿_root.装备生命周期函数.吉他喷火初始化 = function(反射对象, 参数对象) 
{
   反射对象.子弹属性 = 反射对象.子弹配置.bullet_0;//通过反射对象传参通讯
   反射对象.成功率 = 参数对象.probability ? 参数对象.probability : 3;

   反射对象.常时刀光样式 = 参数对象.normalStyle ? 参数对象.normalStyle : "白色蓝框";
   反射对象.轻载刀光样式 = 参数对象.lowStyle ? 参数对象.lowStyle : "蓝色幽灵";
   反射对象.重载刀光样式 = 参数对象.heavyStyle ? 参数对象.heavyStyle : "蓝色魅影";
   反射对象.超载刀光样式 = 参数对象.overStyle ? 参数对象.overStyle : "红色透明";

   反射对象.当前帧 = 1;
   反射对象.动画帧 = 1;
   反射对象.动画时长 = 15;

   反射对象.过载值 = 0;
   反射对象.过载阈值 = 参数对象.threshold ? 参数对象.threshold : 120;
   反射对象.过载释放值 = 参数对象.output ? 参数对象.output : 20;
};

_root.装备生命周期函数.吉他喷火周期 = function(反射对象, 参数对象) 
{
   _root.装备生命周期函数.移除异常周期函数(反射对象);
   var 自机 = 反射对象.自机;
   var 刀 = 自机.刀_引用;
   var 启动许可 = false;
   var 超载许可 = 反射对象.过载值 >= 反射对象.过载阈值;

   if(_root.兵器使用检测(自机))
   {
      var 刀光样式 = 超载许可 ? 反射对象.超载刀光样式 : 反射对象.常时刀光样式;
      if(反射对象.当前帧 < 反射对象.动画时长)
      {
         反射对象.当前帧++;
      }

      if (_root.兵器攻击检测(自机)) 
      {
         启动许可 = true;

         if(超载许可)
         {
            刀光样式 = 反射对象.超载刀光样式;
            if(_root.成功率(反射对象.成功率))
            {
               var 刀口 = 刀.刀口位置3;
               var 坐标 = {x:刀口._x,y:刀口._y};
               刀口._parent.localToGlobal(坐标);
               _root.gameworld.globalToLocal(坐标);
               反射对象.子弹属性.shootX = 坐标.x;
               反射对象.子弹属性.shootY = 坐标.y;
               反射对象.子弹属性.shootZ = 自机.Z轴坐标;

               _root.子弹区域shoot传递(反射对象.子弹属性);
               反射对象.过载值 -= 反射对象.过载释放值;
            }
         }
         else
         {
            if(反射对象.过载值 < 反射对象.过载阈值 / 2)
            {
               刀光样式 = 反射对象.轻载刀光样式;
            }
            else
            {
               刀光样式 = 反射对象.重载刀光样式;
            }
         }   
      }

      _root.刀光系统.刀引用绘制刀光(自机, 自机.刀_引用, 刀光样式);
   }
   else
   {
      if(反射对象.当前帧 > 1)
      {
         反射对象.当前帧--;
      }
   }

   反射对象.动画帧 = 反射对象.当前帧;
   刀.动画.gotoAndStop(反射对象.动画帧);

   if(启动许可)
   {
      反射对象.过载值++;
   }
   else if(反射对象.过载值 > 0)
   {
      反射对象.过载值--;
   }
//_root.服务器.发布服务器消息("电感切割刃周期");
};
