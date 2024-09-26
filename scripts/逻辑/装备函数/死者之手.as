﻿_root.装备生命周期函数.死者之手初始化 = function(反射对象, 参数对象) 
{
   var 自机 = 反射对象.自机;
   var 子弹属性 = _root.子弹属性初始化(null, 诛神闪电, 自机);

   子弹属性.声音 = "";
   子弹属性.霰弹值 = 1;
   子弹属性.子弹散射度 = 1;
   子弹属性.子弹种类 = 参数对象.bullet ? 参数对象.bullet : "诛神闪电";

   var power = 参数对象.power;
   var split_temp = Number(power.split("%")[0]);
   var 子弹威力;
   if(power.indexOf("%")  === power.length - 1 && split_temp > 0)
   {
      子弹威力 = split_temp / 100 * 自机.刀属性数组[13];
   }
   else
   {
      子弹威力 = power ? power : 400;
   }

   子弹属性.子弹威力 = 子弹威力;

   子弹属性.子弹速度 = 0;
   子弹属性.Z轴攻击范围 = 参数对象.range ? 参数对象.range : 300;
   子弹属性.击倒率 = 1;

   反射对象.子弹属性 = 子弹属性;//通过反射对象传参通讯
   反射对象.成功率 = 参数对象.probability ? 参数对象.probability : 3;

   反射对象.近战模式 = false;
   反射对象.超载模式 = false;
   反射对象.超载切换间隔 = 1000; //切换检测的间隔
   反射对象.是否使用中 = false;

   反射对象.枪头收纳帧 = 1;
   反射对象.枪头近战起始帧 = 2;
   反射对象.枪头近战结束帧 = 16;
   反射对象.枪头近战超载起始帧 = 17;
   反射对象.枪头近战超载结束帧 = 31;
   反射对象.枪头射击起始帧 = 32;
   反射对象.枪头射击结束帧 = 46;
   反射对象.枪头当前帧 = 反射对象.枪头收纳帧;

   反射对象.御坂收纳帧 = 1;
   反射对象.御坂展开起始帧 = 2;
   反射对象.御坂展开结束帧 = 16;
   反射对象.御坂当前帧 = 反射对象.御坂收纳帧;

   反射对象.握柄收纳帧 = 1;
   反射对象.握柄打击桩起始帧 = 2;
   反射对象.握柄打击桩结束帧 = 16;
   反射对象.握柄副手柄起始帧 = 17;
   反射对象.握柄副手柄结束帧 = 31;
   反射对象.握柄完全展开起始帧 = 32;
   反射对象.握柄完全展开结束帧 = 46;
   反射对象.握柄当前帧 = 反射对象.握柄收纳帧;

   if (自机.长枪 == "")
   {
      _root.长枪配置(自机._name,"死者之手",1);//借用配置生成因此不需要考虑强化数值
      自机.长枪 = 自机.刀;
      自机.长枪_装扮 = 自机.刀_装扮;
      自机.刀属性数组[13] = 自机[基础属性名].基础伤害 * 130 / 120;//刀模式伤害调整
      自机.长枪_引用._visible = false;
      //_root.发布调试消息(自机.刀 + " " + 自机.刀属性数组[13]);
   }

   _root.装备生命周期函数.死者之手周期(反射对象, 参数对象);
};

_root.装备生命周期函数.死者之手周期 = function(反射对象, 参数对象) 
{
   _root.装备生命周期函数.移除异常周期函数(反射对象);
   var 自机 = 反射对象.自机;

   switch(自机.攻击模式)
   {
      case "长枪":
         自机.长枪_引用._visible = true;
         自机.刀_引用._visible = false;
         反射对象.近战模式 = false;
         反射对象.是否使用中 = true;
         反射对象.武器 = 自机.长枪_引用;
         break;

      case "兵器":
         自机.长枪_引用._visible = false;
         自机.刀_引用._visible = true;
         反射对象.近战模式 = true;
         反射对象.是否使用中 = true;
         反射对象.武器 = 自机.刀_引用;
         break;

      default:
         反射对象.是否使用中 = _root.兵器使用检测(自机);
         反射对象.近战模式 = 反射对象.是否使用中;
         反射对象.刀_引用._visible = true;
         反射对象.长枪_引用._visible = false;
         反射对象.武器 = 自机.刀_引用;
         break;//技能中
   }

   if(_root.按键输入检测(自机, _root.武器变形键))
   {
      _root.更新并执行时间间隔动作(反射对象,"死者之手超载切换检测",function(反射对象){
         反射对象.超载模式 = !反射对象.超载模式;
      }, 反射对象.超载切换间隔, false, 反射对象);
   }

   if(反射对象.是否使用中)
   {
      _root.装备生命周期函数.死者之手展开动画(反射对象);
   }
   else
   {
      _root.装备生命周期函数.死者之手收纳动画(反射对象);
   }

   if(_root.兵器使用检测(自机))
   {
      if (_root.兵器攻击检测(自机)) 
      {
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
            }
         } 
      }
   }
};

_root.装备生命周期函数.死者之手收纳动画 = function(反射对象)
{
   var 自机 = 反射对象.自机;

   switch(反射对象.枪头当前帧)
   {
      case 反射对象.枪头收纳帧:
      case 反射对象.枪头近战起始帧:
      case 反射对象.枪头近战超载起始帧:
      case 反射对象.枪头射击起始帧:
         break;//动画结束

      default: --反射对象.枪头当前帧;
         break;
   }

   反射对象.武器.枪头组件.gotoAndStop(反射对象.枪头当前帧);

   switch(反射对象.御坂当前帧)
   {
      case 反射对象.御坂收纳帧:
      case 反射对象.御坂展开起始帧:
         break;//动画结束

      default: --反射对象.御坂当前帧;
         break;
   }

   反射对象.武器.御坂组件.gotoAndStop(反射对象.御坂当前帧);

   switch(反射对象.握柄当前帧)
   {
      case 反射对象.握柄收纳帧:
      case 反射对象.握柄打击桩起始帧:
      case 反射对象.握柄副手柄起始帧:
      case 反射对象.握柄完全展开起始帧:
         break;//动画结束

      default: --反射对象.握柄当前帧;
         break;
   }

   反射对象.武器.握柄组件.gotoAndStop(反射对象.握柄当前帧);
}

_root.装备生命周期函数.死者之手展开动画 = function(反射对象)
{
   var 自机 = 反射对象.自机;

   switch(反射对象.枪头当前帧)
   {
      case 反射对象.枪头收纳帧:
      case 反射对象.枪头近战起始帧:
      case 反射对象.枪头近战超载起始帧:
      case 反射对象.枪头射击起始帧:

         if(反射对象.近战模式)
         {
            反射对象.枪头当前帧 = 反射对象.超载模式 ? 反射对象.枪头近战超载起始帧 : 反射对象.枪头近战起始帧;
         }
         else
         {
            反射对象.枪头当前帧 = 反射对象.枪头射击起始帧;
         }

         ++反射对象.枪头当前帧;
         break;

      case 反射对象.枪头近战结束帧:

         if(!反射对象.近战模式 || 反射对象.超载模式)
         {
            --反射对象.枪头当前帧;
         }
         break;

      case 反射对象.枪头近战超载结束帧:

         if(!反射对象.近战模式 || !反射对象.超载模式)
         {
            --反射对象.枪头当前帧;
         }
         break;

      case 反射对象.枪头射击结束帧:

         if(反射对象.近战模式)
         {
            --反射对象.枪头当前帧;
         }
         break;

      default:

         if(反射对象.枪头当前帧 < 反射对象.枪头近战结束帧)
         {
            if(反射对象.近战模式 && !反射对象.超载模式)
            {
               ++反射对象.枪头当前帧;
            }
            else
            {
               --反射对象.枪头当前帧;
            }
         }
         else if(反射对象.枪头当前帧 < 反射对象.枪头近战超载结束帧)
         {
            if(反射对象.近战模式 && 反射对象.超载模式)
            {
               ++反射对象.枪头当前帧;
            }
            else
            {
               --反射对象.枪头当前帧;
            }
         }
         else
         {
            if(!反射对象.近战模式)
            {
               ++反射对象.枪头当前帧;
            }
            else
            {
               --反射对象.枪头当前帧;
            }
         }
         break;
   }

   反射对象.武器.枪头组件.gotoAndStop(反射对象.枪头当前帧);

   switch(反射对象.御坂当前帧)
   {
      case 反射对象.御坂收纳帧:
      case 反射对象.御坂展开起始帧:

         if(反射对象.超载模式)
         {
            反射对象.御坂当前帧 = 反射对象.御坂展开起始帧 + 1;
         }
         break;

      case 反射对象.御坂展开结束帧:

         if(!反射对象.超载模式)
         {
            --反射对象.御坂当前帧;
         }
         break;

      default:

         反射对象.御坂当前帧 += 反射对象.超载模式 ? 1 : -1;
   }

   反射对象.武器.御坂组件.gotoAndStop(反射对象.御坂当前帧);

   switch(反射对象.握柄当前帧)
   {
      case 反射对象.握柄收纳帧:
      case 反射对象.握柄打击桩起始帧:
      case 反射对象.握柄副手柄起始帧:
      case 反射对象.握柄完全展开起始帧:

         if(反射对象.近战模式)
         {
            反射对象.握柄当前帧 = (反射对象.超载模式 ? 反射对象.握柄完全展开起始帧 : 反射对象.握柄副手柄起始帧) + 1;
         }
         break;

      case 反射对象.握柄打击桩结束帧:

           // todo
         break;

      case 反射对象.握柄副手柄结束帧:

         if(反射对象.超载模式 || !反射对象.近战模式)
         {
            --反射对象.握柄当前帧;
         }
         break;

      case 反射对象.握柄完全展开结束帧:

         if(!反射对象.超载模式 || !反射对象.近战模式)
         {
            --反射对象.握柄当前帧;
         }
         break;

      default:

         if(反射对象.握柄当前帧 < 反射对象.握柄打击桩结束帧)
         {
             // todo
         }
         else if(反射对象.握柄当前帧 < 反射对象.握柄副手柄结束帧)
         {
            if(反射对象.超载模式 || !反射对象.近战模式)
            {
               --反射对象.握柄当前帧;
            }
            else
            {
               ++反射对象.握柄当前帧;
            }
         }
         else
         {
            if(!反射对象.超载模式 || !反射对象.近战模式)
            {
               --反射对象.握柄当前帧;
            }
            else
            {
               ++反射对象.握柄当前帧;
            }
         }
         break;
   }

   反射对象.武器.握柄组件.gotoAndStop(反射对象.握柄当前帧);
   _root.服务器.发布服务器消息(反射对象.武器.握柄组件 + " " + 反射对象.握柄当前帧);
}


