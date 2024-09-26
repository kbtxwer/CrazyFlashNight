﻿_root.刀光系统 = {};
_root.刀光系统.初始化 = function () 
{
    this.刀光样式 = {
        预设: {
            颜色: 0xFFFFFF,
            线条颜色: 0xFFFFFF,
            线条宽度: 2,
            填充透明度: 100,
            线条透明度: 100
        },
        白色蓝框: {
            颜色: 0xFFFFFF,
            线条颜色: 0x4FB6FF,
            线条宽度: 2,
            填充透明度: 50,
            线条透明度: 50
        },
        红色透明: {
            颜色: 0xFF6666,
            线条颜色: 0xFF6666,
            线条宽度: 2,
            填充透明度: 50,
            线条透明度: 50
        },
        蓝色魅影: {
            颜色: 0x4DE6FF,
            线条颜色: 0x4FB6FF,
            线条宽度: 2,
            填充透明度: 50,
            线条透明度: 50
        },
        蓝色幽灵: {
            颜色: 0x74EBFF,
            线条颜色: 0x74EBFF,
            线条宽度: 2,
            填充透明度: 25,
            线条透明度: 25
        }
    };
    this.绘制记录 = {};
    this.绘制阈值 = _root.帧计时器.帧率 * 2;
    //_root.服务器.发布服务器消息("刀光系统初始化完成");
};

_root.刀光系统.初始化();

_root.刀光系统.绘制刀及其刀光 = function(影片剪辑:MovieClip, 刀光样式名:String, 参数:Object) {
    _root.残影系统.绘制元件(影片剪辑.man.刀, 参数);
    this.绑定并绘制刀光(影片剪辑, 刀光样式名);
};

_root.刀光系统.绘制人物及其刀光 = function(影片剪辑:MovieClip, 刀光样式名:String, 参数:Object) {
    _root.残影系统.绘制元件(影片剪辑, 参数);
    this.绑定并绘制刀光(影片剪辑, 刀光样式名);
};
    

_root.刀光系统.绑定并绘制刀光 = function(影片剪辑:MovieClip, 刀光样式名:String) {
    var 刀口集合 = [];
    var 游戏世界 = _root.gameworld;
    var 装扮 = 影片剪辑.man.刀.刀.装扮;
    for (var i = 1; i <= 5; i++) {
        var 当前刀口 = 装扮["刀口位置" + i];
        if (当前刀口._x) {
            var myPoint = {x:当前刀口._x, y:当前刀口._y};
            装扮.localToGlobal(myPoint);
            游戏世界.globalToLocal(myPoint);
            刀口集合.push(当前刀口);
        }
    }
    //_root.服务器.发布服务器消息("刀口位置绑定到刀口集合: " + _root.格式化对象为字符串(刀口集合));
    if (刀口集合.length > 0) {
        _root.刀光系统.绘制刀光(影片剪辑._name, 刀口集合, 刀光样式名);
    }
};

_root.刀光系统.刀引用绘制刀光 = function(自机:MovieClip, 影片剪辑:MovieClip, 刀光样式名:String) {
    var 刀口集合 = [];
    var 游戏世界 = _root.gameworld;

    for (var i = 1; i <= 5; i++) {
        var 当前刀口 = 影片剪辑["刀口位置" + i];
        if (当前刀口._x) {
            var myPoint = {x:当前刀口._x, y:当前刀口._y};
            影片剪辑.localToGlobal(myPoint);
            游戏世界.globalToLocal(myPoint);
            刀口集合.push(当前刀口);
        }
    }
    //_root.服务器.发布服务器消息("刀口位置绑定到刀口集合: " + _root.格式化对象为字符串(刀口集合));
    if (刀口集合.length > 0) {
        _root.刀光系统.绘制刀光(自机, 刀口集合, 刀光样式名);
    }
};


_root.刀光系统.绘制刀光 = function(发射者, 刀口集合, 刀光样式名) {
    var 当前帧 = _root.帧计时器.当前帧数;
    //_root.服务器.发布服务器消息("绘制刀光开始: 发射者=" + 发射者 + ", 当前帧=" + 当前帧);
    
    var 新点集数组 = [];
    for (var i = 0; i < 刀口集合.length; i++) {
        var 点集 = _root.影片剪辑至游戏世界点集(刀口集合[i]);
        新点集数组.push(点集);
    }
    //_root.服务器.发布服务器消息("刀口位置集合: " + _root.格式化对象为字符串(新点集数组));

    if (!this.绘制记录[发射者]) {
        this.绘制记录[发射者] = {
            最后绘制帧: 当前帧,
            点集数组: 新点集数组
        };
        //_root.服务器.发布服务器消息("第一次记录发射者 " + 发射者);
        return;
    }

    var 记录 = this.绘制记录[发射者];
    if (当前帧 - 记录.最后绘制帧 >= this.绘制阈值) {
        记录.最后绘制帧 = 当前帧;
        记录.点集数组 = 新点集数组;
        //_root.服务器.发布服务器消息("记录更新但未绘制，发射者: " + 发射者);
    } else {
        for (var j = 0; j < 记录.点集数组.length; j++) {
            var 临时点集 = this.连接刀口点集(记录.点集数组[j], 新点集数组[j]);
            this.绘制于残影系统(临时点集, 刀光样式名);
        }
        记录.点集数组 = 新点集数组;
       // _root.服务器.发布服务器消息("绘制完成并更新记录，发射者: " + 发射者);
    }
};

_root.刀光系统.绘制于残影系统 = function(刀口点集, 刀光样式名) {
    var 样式 = this.刀光样式[刀光样式名] || this.刀光样式['预设'];
    //_root.服务器.发布服务器消息("绘制于残影系统，点集: " + _root.格式化对象为字符串(刀口点集) + ", 样式: " + 刀光样式名);
    _root.残影系统.绘制形状(刀口点集, 样式.颜色, 样式.线条颜色, 样式.线条宽度, 样式.填充透明度, 样式.线条透明度);
};


_root.刀光系统.连接刀口点集 = function(旧点集, 新点集) 
{
    var 连接后点集 = _root.凸包Jarvis步进(旧点集.concat(新点集));
    //_root.服务器.发布服务器消息("连接刀口点集, 旧点集: " + _root.格式化对象为字符串(旧点集) + ", 新点集: " + _root.格式化对象为字符串(新点集));
    return 连接后点集;
};
