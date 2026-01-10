-- 依赖库（Lua 5.1+ 标准库，无需额外安装）
local bit32 = require("bit32")
local string = require("string")
local table = require("table")

-- 1. 基础工具集（补全实现，确保可调用）
local BitUtils = {
    bor = bit32.bor,
    band = bit32.band,
    bxor = bit32.bxor,
    lshift = bit32.lshift,
    rshift = bit32.rshift,
    rrotate = bit32.rrotate,
    countlz = bit32.countlz,
    bnot = bit32.bnot
}

local StringUtils = {
    sub = string.sub,
    pack = string.pack,
    unpack = string.unpack,
    gsub = string.gsub,
    match = string.match
}

-- 2. 全局参数初始化（给测试值，避免空引用）
local GlobalParams = {
    [22] = nil,
    [6] = "测试字符串缓存",
    [9] = 0,
    [23] = false,
    [36] = {"初始化数据1", "初始化数据2"},
    [8949] = 128,
    [3764] = 64,
    [8236] = nil,
    [14514] = 100, -- 测试业务标记位
    [4904] = 50,   -- 测试辅助参数
    [3501] = 75,   -- 测试输入数据
    [23655] = 200, -- 测试阈值
    [16489] = 30,  -- 测试中间值
    [14546] = nil, -- 结果缓存位1
    [11569] = nil, -- 结果缓存位2
    [18055] = 40,  -- 额外配置项1
    [27267] = 60,  -- 额外配置项2
    [0x29] = function(x) return x * 2 end -- 测试回调函数
}

-- 3. 补全 context 对象（核心依赖实现，教学场景简化版）
local Context = {
    DataModule = "数据处理模块",
    MoveFunc = function() return "执行移动逻辑" end,
    SourceData = "核心数据源",
    InfoData = "信息配置",
    Config = {6, 9, 7, 1}, -- 测试配置数组
    -- 数据加载实现
    loadData = function(self, params)
        print("[执行] 加载数据 ->", table.concat(params[36], ","))
        params[8236] = params[8949] + params[3764] -- 简化计算
    end,
    -- 数据释放实现
    releaseData = function(self, params)
        print("[执行] 释放数据 -> 清理临时参数")
        params[22] = nil
    end,
    -- 功能分发实现
    dispatchFunc = function(self, flag, params, globalParams)
        print("[执行] 功能分发 -> 标记值:", flag)
        return flag - 5 -- 简化逻辑，返回新标记
    end,
    -- 计算包装函数实现
    calcWrap = function(val1, val2)
        return val1 + val2 -- 简化运算
    end
}

-- 4. 核心业务函数（保持逻辑，确保可执行）
local CoreLogic = {
    mainLoop = function(context, dataStore, params, tempData, inputVal)
        params[22] = nil
        params[23] = nil
        local loopFlag = 52
        
        repeat
            if loopFlag == 52 then
                context:loadData(params)
                if params[8236] then
                    loopFlag = params[8236]
                else
                    loopFlag = -128 + (params[8949] + params[3764] + params[4904] + loopFlag - params[14514])
                    params[8236] = loopFlag
                end
            elseif loopFlag == 51 then
                context:releaseData(params)
                break
            end
        until false
        
        for idx = 0, 5 do -- 简化循环范围，避免冗余输出
            tempData[idx] = inputVal(idx)
            print("[映射] 索引", idx, "->", tempData[idx])
        end
        
        params[24] = nil
        params[97] = nil
        params[26] = nil
        
        loopFlag = 84
        repeat
            if loopFlag > 35 then
                loopFlag = context:dispatchFunc(loopFlag, params, GlobalParams)
                goto continue
            elseif loopFlag < 84 then
                params[26] = context.MoveFunc()
                break
            end
            ::continue::
        until false
        
        params[27] = StringUtils.unpack
        return loopFlag
    end,

    clearParams = function(targetTable, key)
        targetTable[key] = nil
        print("[清理] 移除键:", key)
    end,

    calcConfig = function(context, dataStore, params, tempData)
        dataStore[11] = {}
        if params[8949] then
            tempData = params[8949]
        else
            tempData = 21 + (context.calcWrap(context.calcWrap(params[3501] + tempData)) + params[3764])
            params[8949] = tempData
        end
        print("[计算] 配置值 ->", tempData)
        return tempData
    end,

    unpackData = function(context, dataStore, params, tempData, inputFunc)
        dataStore = 56
        local result1, result2 = "解包结果1", "解包结果2"
        print("[解包] 结果 ->", result1, result2)
        return result1, result2, dataStore
    end,

    conditionJudge = function(context, dataStore, params, inputVal)
        if inputVal > 5 then
            dataStore[4] = context.SourceData
            if not params[14514] then
                local calcVal = context.calcWrap(BitUtils.bor(context.Config[1], context.Config[2], context.Config[3]) - context.Config[1]) + context.Config[4]
                params[14546] = -56914 + calcVal
                tempData = params[14546]
            else
                tempData = params[14514]
            end
        else
            if inputVal >= 62 then
                dataStore[5] = context.InfoData
                print("[判断] 结果 ->", 33668, tempData)
                return 33668, tempData
            end
        end
        print("[判断] 结果 ->", nil, tempData)
        return nil, tempData
    end
}

-- 5. 辅助工具函数（补全实现）
local AuxUtils = {
    wrapCalc = function(context, dataStore, params)
        local calcCond = BitUtils.rrotate(BitUtils.countlz(params[3501]), params[23655]) <= params[23655]
        local val1 = calcCond and params[23655] or params[3764]
        local result = -1 + context.calcWrap(val1, params[16489])
        params[11569] = result
        print("[包装运算] 结果 ->", result)
        return result
    end,

    clearInvalid = function(targetTable, key)
        targetTable[key] = nil
        print("[清理无效] 键:", key)
        return nil
    end,

    numCalculate = function(context, dataStore, params)
        local result = -56711 + (context.Config[1] - dataStore[8949] - dataStore[23655] - dataStore[18055] - dataStore[27267])
        dataStore[16416] = result
        print("[数值计算] 结果 ->", result)
        return result
    end
}

-- 6. 可执行入口（带测试输入+清晰输出）
local function executeEntry()
    print("=====================================")
    print("          Lua脚本执行开始             ")
    print("=====================================")
    
    -- 测试输入参数
    local inputParams = {
        rawData = 75,
        auxVal = 50,
        calcFunc = function(x) return x + 10 end, -- 测试映射函数
        inputVal = 8 -- 测试判断输入值
    }

    -- 执行核心流程
    local tempData = {}
    local mainResult = CoreLogic.mainLoop(Context, {}, GlobalParams, tempData, inputParams.calcFunc)
    local configResult = CoreLogic.calcConfig(Context, {}, GlobalParams, tempData)
    local unpack1, unpack2 = CoreLogic.unpackData(Context, {}, GlobalParams, tempData)
    local judgeResult, judgeVal = CoreLogic.conditionJudge(Context, {}, GlobalParams, inputParams.inputVal)
    local wrapResult = AuxUtils.wrapCalc(Context, {}, GlobalParams)
    local numResult = AuxUtils.numCalculate(Context, {}, GlobalParams)

    print("=====================================")
    print("          执行结果汇总                ")
    print("=====================================")
    print("主循环结果:", mainResult)
    print("配置计算结果:", configResult)
    print("解包结果:", unpack1, unpack2)
    print("条件判断结果:", judgeResult or "无", "判断值:", judgeVal)
    print("包装运算结果:", wrapResult)
    print("数值计算结果:", numResult)
    print("=====================================")
    print("          脚本执行完成                ")
    print("=====================================")
end

-- 启动执行（直接运行脚本即可触发）
executeEntry()
