-- 依赖库（原代码隐含的bit32位操作库）
local bit32 = require("bit32")

-- 全局常量配置（原混淆的固定参数，还原语义）
local GlobalConfig = {
    MoveSpeed = 16,          -- 原0X10：业务常量（如移动速度）
    JumpPower = 50,          -- 原0X32：业务常量（如跳跃力度）
    MaxLevel = 5,            -- 原0X5：业务常量（最大关卡）
    SaveKey = "HomeworkData",-- 原0X27：数据存储键名
    BitMask = 0X1F3D,        -- 原0B1111100111101：位运算掩码
    InitCount = 66,          -- 原0B1000010：循环初始值
    DefaultValue = 128       -- 原0X80：默认填充值
}

-- 工具函数库（还原原混淆的bit32/table/string工具）
local Tool = {
    -- 位操作（原eI/AI/YI/jI等）
    count_leading_zero = bit32.countlz,  -- 统计前导零
    bit_or = bit32.bor,                  -- 位或运算
    bit_left_shift = bit32.lshift,       -- 左移运算
    bit_right_shift = bit32.rshift,      -- 右移运算
    bit_not = bit32.bnot,                -- 位非运算
    bit_and = bit32.band,                -- 位与运算
    -- 表操作（原aI/RI等）
    table_insert = table.insert,         -- 表插入
    table_remove = table.remove,         -- 表删除
    table_clear = function(t) for k in pairs(t) do t[k] = nil end end, -- 表清空
    -- 字符串操作（原QI/RI等）
    string_sub = string.sub,             -- 字符串截取
    string_byte = string.byte,           -- 字符转ASCII
    string_unpack = string.unpack,       -- 字符串解包
    string_pack = string.pack,           -- 字符串打包
    -- 通用工具
    is_valid = function(val) return val ~= nil and val ~= "" end, -- 有效性判断
    default_val = function(val, def) return Tool.is_valid(val) ? val : def end -- 默认值填充
}

-- 全局数据存储（原混淆的r/n/y等全局变量，还原语义）
local GlobalData = {
    LocalPlayer = nil,      -- 玩家对象
    PlayerCharacter = nil,  -- 角色对象
    PlayerHumanoid = nil,   -- 人形对象
    SaveData = {            -- 存档数据
        Level = 1,
        Score = 0
    },
    UI_Components = {},     -- UI组件缓存
    TempCache = {}          -- 临时计算缓存
}-- 原PL函数：主循环调度（还原后）
local function main_cycle(process, params, temp_data, cache)
    -- 初始化参数清空
    temp_data[32] = nil
    temp_data[17] = nil
    temp_data[34] = nil
    local cycle_count = GlobalConfig.InitCount
    
    repeat
        if cycle_count > GlobalConfig.InitCount then
            local judge_result, new_count = judge_logic(cycle_count, process, temp_data)
            if judge_result == 11548 then  -- 原0X2D1C：循环终止标记
                break
            elseif judge_result == 26059 then -- 原0X65B3：循环继续标记
                cycle_count = new_count
                goto continue
            end
        else
            cycle_count = zero_logic(cycle_count, temp_data, process)
        end
        ::continue::
    until false
    return cycle_count
end

-- 原R函数：配置计算（还原后）
local function calc_config(process, params, temp_data)
    params[8949] = {}  -- 原0X22F5：配置存储表
    if Tool.is_valid(params[8949]) then
        temp_data = params[8949]
    else
        -- 原混淆的运算逻辑还原
        temp_data = 21 + (Tool.bit_or(params[3501] + temp_data) + params[3764])
        params[8949] = temp_data
    end
    return temp_data
end

-- 原XL函数：字符串逻辑处理（还原后）
local function string_logic(process, temp_data, input_str)
    -- 原混淆的字符串运算还原
    local str_len = #input_str
    local result = str_len + 1
    GlobalData.TempCache[0X23C8] = result  -- 原0B0010001111001000：缓存结果
    return result
end

-- 原iL函数：数据同步（还原后）
local function sync_data(process, params, sync_data)
    params[28] = process.default_val  -- 原0X1C：同步标记位
    if Tool.is_valid(params[0X4020]) then
        sync_data = params[0X4020]
    else
        sync_data = Tool.bit_or(sync_data, params[3764])
    end
    return sync_data
end

-- 原jL函数：循环逻辑处理（还原后）
local function loop_logic(process, params, temp_data, cache)
    if not (params <= 0B101000000) then  -- 原0X140：阈值判断
        temp_data, params = rule_logic(temp_data, params, process, cache)
        return 0X7D6B, temp_data, params  -- 原0X7D6B：逻辑结果标记
    else
        params = string_process(params, cache, process)
    end
    return nil, temp_data, params
end

-- 原RL函数：规则逻辑（还原后）
local function rule_logic(temp_data, params, process, cache)
    local rule_func = function()
        local rule_cache, rule_param = yield_logic(cache, temp_data)
        local loop_count, result_data = nil, nil
        
        -- 原混淆的循环执行逻辑
        for step = 50, 0XF6, 0X62 do  -- 原0X32/0X94/0XF6：循环步长
            if step == 0X32 then
                loop_count = window_logic(cache, loop_count)
            elseif step == 0X94 then
                result_data = cache[0B1000101](loop_count)  -- 原0X25：缓存回调
            elseif step == 0XF6 then
                empty_logic(loop_count, cache)
            end
        end
        
        -- 数据填充逻辑
        for idx = 1, loop_count do
            result_data[idx] = cache[0X2A]()  -- 原0X2A：数据生成回调
        end
        
        -- 执行逻辑分发
        local exec_count = 88  -- 原0X58：执行计数初始值
        while true do
            exec_count, rule_result, rule_cache = exec_logic(rule_param, cache, result_data, exec_count, rule_cache)
            if rule_result == 0XD69F then  -- 原0XD69F：继续标记
                goto continue_exec
            elseif Tool.is_valid(rule_result) then
                return Tool.string_unpack(rule_result)
            end
            ::continue_exec::
        end
    end
    
    -- 原混淆的缓存赋值逻辑
    if Tool.is_valid(temp_data[6737]) then
        params = temp_data[6737]
    else
        params = 0X65E3BF86 + (Tool.bit_or(process.Config[4]) + temp_data[0X5Bd6] + temp_data[9160] - process.Config[8])
        temp_data[6737] = params
    end
    return rule_func, params
end

-- 原DL函数：动态加载（还原后）
local function dynamic_load(process, params, load_type, temp_data, load_data)
    if load_type == 21 then
        load_type = 0X70  -- 原0X70：加载标记
        process, load_data = params[0X1B]('\60d', params[0B11001], params[0B1010])  -- 原0X1B/0B11001/0B1010：加载参数
        return load_type, process, 0X9b88, load_data
    elseif load_type == 0X70 then
        params[0XA] = load_data  -- 原0XA：数据缓存
        return load_type, process, -0X2, load_data, process
    end
    return load_type, process, nil, load_data
end

-- 原MI函数：多逻辑整合（还原后）
local function multi_logic(process, params, temp_data, sync_flag, cache, rule_flag, config_key, exec_param)
    if rule_flag > 0Xd4 then  -- 原0XD4：规则阈值
        if sync_flag == 0X6 then
            load_info(process, exec_param, cache, params, temp_data)
        elseif sync_flag == 5 then
            update_store(exec_param, params, config_key)
        elseif sync_flag == 0X7 then
            exec_param[params] = params + config_key
        elseif sync_flag == 2 then
            exec_param[params] = params - config_key
        elseif sync_flag == 0X0 then
            local cache_idx = #temp_data[0X27]
            temp_data[0X27][cache_idx+1] = cache
            temp_data[39][cache_idx+2] = params
            temp_data[41][cache_idx+3] = config_key
        end
        return 0XCB3B  -- 原0XCB3B：逻辑结果标记
    els-- 原YL函数：yield逻辑处理（还原后）
local function yield_logic(cache, temp_data)
    local yield_cache, yield_param = nil, nil
    temp_data = nil
    local yield_count = 0B1101000  -- 原0X68：计数初始值
    
    while true do
        if yield_count > 0X68 then
            temp_data = cache[0B11110]() ~= 0  -- 原0X1E：缓存判断
            yield_count = 0B11100  -- 原0X1C：计数更新
        elseif yield_count < 0X27 then
            cache[0X17] = temp_data
            for config_idx = 1, yield_param do
                local tool_cache, tool_param = nil, nil
                for step = 0B10000001, 0B11010101, 79 do  -- 原0X81/0XD5/0X4F
                    local query_result = query_logic(config_idx, step, tool_param, cache, tool_cache, temp_data)
                    if query_result == 0X65B4 then  -- 原0X65B4：终止标记
                        break
                    end
                end
            end
            break
        elseif yield_count < 0X71 and yield_count > 0X27 then
            yield_count = 0X71
            cache[0X1C] = cache[0X15](yield_param)  -- 原0X15：缓存处理
        elseif yield_count < 0X71 and yield_count > 0X5A then
            cache[0X8] = {}
            yield_count = 0X27
        elseif yield_count > 28 and yield_count < 0X5A then
            yield_count, yield_param = aux_loop(yield_param, cache, yield_count)
        end
    end
    return temp_data, yield_param
end

-- 原EL函数：执行逻辑处理（还原后）
local function exec_logic(rule_param, cache, result_data, exec_count, rule_cache)
    if exec_count == 88 then
        for config_idx = 1, #result_data[0B100111], 0B11 do  -- 原0X27/0X3
            result_data[0X27][config_idx][result_data[39][config_idx+1]] = cache[result_data[39][config_idx+2]]
        end
        exec_count = 0X57  -- 原0X57：计数更新
    elseif exec_count == 0X57 then
        exec_count = outer_unpack(process, result_data, exec_count, cache)
        return exec_count, 0XD69F, rule_cache
    elseif exec_count == 0X4A then
        rule_cache = cache[result_data[36]()]
        exec_count = 0B10000111  -- 原0X87：计数更新
        return exec_count, 0XD69F, rule_cache
    elseif exec_count == 33 then
        exec_count = bit_data_logic(exec_count, result_data)
        return exec_count, 0XD69F, rule_cache
    elseif exec_count == 12 then
        result_data[39] = nil
        exec_count = 0B11110111  -- 原0XF7：计数更新
    elseif exec_count == 0X7B then
        return exec_count, {func_unpack(result_data, rule_cache)}, rule_cache
    end
    return exec_count, nil, rule_cache
end

-- 原wrapCalc函数：包装计算（还原后）
local function wrap_calc(input_val)
    return Tool.bit_or(input_val, GlobalConfig.DefaultValue)
end

-- 原loadInfo函数：加载信息（还原后）
local function load_info(process, exec_param, cache, params, temp_data)
    if temp_data[0X17] then
        local load_cache, config_cache, tool_cache = 0B101  -- 原0X5：计数初始值
        repeat
            if not (load_cache <= 0B101) then
                if load_cache == 0X20 then
                    tool_cache = #config_cache
                    config_cache[tool_cache+1] = process
                    load_cache = 0X52  -- 原0X52：计数更新
                else
                    config_cache[tool_cache+2] = cache
                    break
                end
            else
                config_cache = temp_data[0B11100][exec_param]  -- 原0X1C：缓存读取
                load_cache = 0B100000  -- 原0X20：计数更新
            end
        until false
        config_cache[tool_cache+3] = 0X6
    else
        params[cache] = temp_data[0X1C][exec_param]
    end
end

-- 原updateStore函数：更新存储（还原后）
local function update_store(store_table, key, value)
    store_table[key] = value
    Tool.table_insert(GlobalData.TempCache, {key, value})  -- 缓存操作记录
end

-- 原initInfo函数：初始化信息（还原后）
local function init_info(process, target_table, index)
    target_table[index+1] = process
end

-- 原verifyParam函数：验证参数（还原后）
local function verify_param(process, params, judge_count, rule_cache, config_cache)
    return judge_count + 1
end

-- 原dataInit函数：数据初始化（还原后）
local function data_init(data_table, cache_idx, init_val)
    data_table[39][cache_idx+3] = init_val
end

-- 原bitDataLogic函数：位数据处理（还原后）
local function bit_data_logic(exec_count, data_table)
    data_table[28] = process.default_val
    return exec_count
end

-- 原outerUnpack函数：外部解包（还原后）
local function outer_unpack(process, data_table, exec_count, cache)
    local unpack_cache = nil
    if process then
        local unpack_count = 0X2F  -- 原0X2F：计数初始值
        while true do
            unpack_cache, unpack_count = yield_unpack(unpack_count, data_table, exec_count)
            if unpack_cache ~= 0X68B1 then  -- 原0X68B1：终止标记
                break
            end
        end
    end
    cache = 0B1001010  -- 原0X4A：缓存更新
    return cache
end

-- 原yieldUnpack函数：yield解包（还原后）
local function yield_unpack(unpack_count, data_table, exec_count)
    return 0, unpack_count + 1
end

-- 原auxLoop函数：辅助循环（还原后）
local function aux_loop(yield_param, cache, yield_count)
    return 90, cache[4982]() - 30178  -- 原0X787E：计算逻辑
end

-- 原fun-- 原nestedDispatch函数：嵌套逻辑分发（还原后）
local function nested_dispatch(process, params, temp_data, cache)
    if cache == 101 then
        cache = nested_func(temp_data, cache, process)
        return params, 3715, cache
    elseif cache == 16 then
        params[15] = string.gsub  -- 原J.gsub：字符串替换
        if not temp_data[6182] then
            cache = -11 + (Tool.bit_right_shift(Tool.bit_right_shift(Tool.bit_or(process.Config[7], temp_data[11569], process.Config[9]), temp_data[17628]), temp_data[0X2E9A]) + temp_data[0X44DC])
            temp_data[6182] = cache
        else
            cache = temp_data[6182]
        end
        return params, 3619, cache
    elseif cache == 47 then
        params[16] = 9007199254740992  -- 原0X1FFFFFFFFFFFFFFF：最大值
        if temp_data[13049] then
            cache = temp_data[13049]
        else
            cache = -4005771338 + (Tool.bit_not(temp_data[0X48Ef] + process.Config[9] + temp_data[3501]) - temp_data[0X1A8B])
            temp_data[13049] = cache
        end
        return params, 3715, cache
    elseif cache == 66 then
        params = {}
        if not temp_data[16388] then
            cache = config_func(cache, temp_data)
            temp_data[4004] = cache
        else
            cache = temp_data[4004]
        end
    elseif cache == 57 then
        pack_func(process)
        return params, 57862, cache
    end
    return params, nil, cache
end

-- 原configFunc函数：配置函数（还原后）
local function config_func(cache, temp_data)
    temp_data[0X4B93] = -2733813329 + (Tool.bit_or(temp_data[0X57D0], process.Config[4], temp_data[17280]) - process.Config[4] + temp_data[11930] <= temp_data[3764] and process.Config[8] or temp_data[11569])
    temp_data[0X5BD6] = -221175 + (Tool.bit_left_shift(Tool.bit_xor(temp_data[8949]) + process.Config[3] ~= temp_data[0X38B2] and temp_data[0X1328] or process.Config[9], temp_data[11930]))
    cache = 0X35 + (Tool.bit_and(Tool.bit_not(Tool.count_leading_zero(temp_data[24962]) + process.Config[7]), temp_data[0X4069], temp_data[11569]))
    return cache
end

-- 原packFunc函数：打包函数（还原后）
local function pack_func(process)
    process[17] = function(params, count, start_idx)
        start_idx = start_idx or 1
        count = count or #params
        if (count - start_idx + 1) > GlobalConfig.BitMask then
            return process[12]()(count, params, start_idx)
        else
            return process[13]()(params, start_idx, count)
        end
    end
end

-- 原mainCycle函数：主循环控制（还原后）
local function main_cycle_control(process, params, temp_data)
    return main_cycle(process, params, temp_data, GlobalData.TempCache)
end

-- 启动执行（原混淆的入口逻辑）
local function start()
    -- 初始化配置
    GlobalData.SaveData = {Level = 1, Score = 0}
    -- 执行主循环
    local cycle_result = main_cycle_control({}, {}, {})
    -- 输出启动日志
    print("作业代码启动成功，主循环执行结果：", cycle_result)
    print("当前存档数据：", GlobalData.SaveData)
end

-- 触发启动
start()