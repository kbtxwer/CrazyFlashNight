﻿class org.flashNight.neur.Controller.PIDController {
    private var kp:Number; // 比例增益
    private var ki:Number; // 积分增益
    private var kd:Number; // 微分增益
    private var errorPrev:Number; // 上一次的误差
    private var integral:Number; // 误差积分
    private var integralMax:Number; // 积分限幅
    private var derivativeFilter:Number; // 微分项滤波器系数
    private var derivativePrev:Number; // 上次的微分项

    // 构造函数
    function PIDController(kp:Number, ki:Number, kd:Number, integralMax:Number, derivativeFilter:Number) {
        this.kp = kp;
        this.ki = ki;
        this.kd = kd;
        this.errorPrev = 0;
        this.integral = 0;
        this.integralMax = (integralMax != undefined) ? integralMax : 1000; // 设定积分限幅
        this.derivativeFilter = (derivativeFilter != undefined) ? derivativeFilter : 0.1; // 微分项滤波
        this.derivativePrev = 0;
    }

    // 更新 PID 控制器，并返回控制输出
    public function update(setPoint:Number, actualValue:Number, deltaTime:Number):Number {
        if (deltaTime <= 0) {
            _root.服务器.发布服务器消息("警告: deltaTime <= 0，返回输出为 0");
            return 0; // 确保 deltaTime > 0
        }
        
        var error:Number = setPoint - actualValue;
        
        // 积分项更新，同时应用反积分饱和
        integral += error * deltaTime;
        integral = Math.max(-integralMax, Math.min(integral, integralMax));
        
        // 微分项平滑处理
        var derivative:Number = (error - errorPrev) / deltaTime;
        derivative = derivativePrev * (1 - derivativeFilter) + derivative * derivativeFilter;
        derivativePrev = derivative;
        
        // 计算 PID 输出
        var output:Number = kp * error + ki * integral + kd * derivative;
        
        // 更新上一次误差
        errorPrev = error;
        
        // 调试信息输出
        //_root.服务器.发布服务器消息(actualValue + " PID 输出: 比例项=" + (kp * error) + ", 积分项=" + (ki * integral) + ", 微分项=" + (kd * derivative) + ", 总输出=" + output);
        
        return output;
    }

    // 设置和获取 PID 参数
    public function setKp(value:Number):Void { kp = value; }
    public function setKi(value:Number):Void { ki = value; }
    public function setKd(value:Number):Void { kd = value; }
    public function getKp():Number { return kp; }
    public function getKi():Number { return ki; }
    public function getKd():Number { return kd; }
}
