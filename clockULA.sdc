# Arquivo SDC - Constraint de Clock para a placa AX301 (EP4CE6F17C8)

# Definindo o clock de 50 MHz (período de 20 ns) a partir do pino de entrada 'clk'
create_clock -name "clk" -period 20.0 [get_ports {clk}]

# Definindo margens de atraso para todas as entradas (opcional, mas recomendado)
set_input_delay -clock clk 5.0 [all_inputs]

# Definindo margens de atraso para todas as saídas
set_output_delay -clock clk 5.0 [all_outputs]
