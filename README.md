# Projeto ULA - Placa AX301 (FPGA EP4CE6F17C8)

## 📌 Descrição Geral

Este projeto implementa uma ULA (Unidade Lógica e Aritmética) para a placa **AX301** com FPGA **Cyclone IV EP4CE6F17C8**.

Funcionalidades principais:

- Operações: Soma, Subtração, AND, OR (selecionadas via `SS`)
- Detecção de Carry Out e Overflow
- Exibição do resultado `F` no display de 7 segmentos (lógica invertida)
- Multiplexação dos displays
- Controle por clock (sequencial)

---

## 📁 Estrutura dos Arquivos

| Arquivo | Descrição |
|---|---|
| `ULA.vhd` | Código VHDL completo da ULA |
| `tb_ULA.vhd` | Testbench para simulação |
| `clock.sdc` | Constraint de clock (50 MHz) |
| `constraints_ax301_final.qsf` | Mapeamento de pinos (Pin Planner) |

---

## ✅ Passo a Passo no Quartus II

### 1. Criar um Novo Projeto

- Abra o **Quartus II Web Edition**
- Vá em:  
`File → New Project Wizard`
- Nome do projeto:  
Exemplo: `Projeto_ULA_AX301`
- Diretório:  
Escolha a pasta onde estão os arquivos `.vhd`, `.qsf` e `.sdc`.

---

### 2. Adicionar os Arquivos ao Projeto

Durante a criação do projeto, na etapa **"Add Files"**, adicione:

- ✅ `ULA.vhd`
- ✅ `clock.sdc`
- ✅ (Opcional para simulação): `tb_ULA.vhd`

---

### 3. Configurar o Dispositivo (FPGA)

- Família: **Cyclone IV E**
- Dispositivo: **EP4CE6F17C8**

---

### 4. Importar o Arquivo de Pinos (.qsf)

Se quiser, você pode:

- Copiar o conteúdo de `constraints_ax301_final.qsf` para o `.qsf` do projeto  
**OU**  
- Abrir o **Pin Planner** e configurar manualmente os pinos conforme o `.qsf`.

---

### 5. Vincular o Arquivo SDC

- Vá em:  
`Assignments → Settings → Timing Analyzer Settings → SDC File`
- Adicione o arquivo:  
✅ `clock.sdc`

---

### 6. Definir o Top-Level Entity

- Vá em:  
`Assignments → Settings → General → Top-Level Entity`
- Defina como:  
✅ `ULA`

---

### 7. Compilar o Projeto

- Vá em:  
`Processing → Start Compilation`

**Pode ignorar os seguintes warnings comuns (não são erro):**

- Warnings sobre **clock uncertainty**
- Warnings sobre **pinos stuck at VCC ou GND (multiplexação dos anodos)**

---

### 8. Gravar na Placa

- Vá em:  
`Tools → Programmer`
- Em **Hardware Setup**, selecione:  
✅ `USB-Blaster`
- No campo **File**, selecione o `.sof` gerado na pasta `/output_files/`
- Clique em **Start**

---

## ✅ Testando na AX301

- **Chaves (KEYs):**
  - KEY1 → Entradas `A[3:0]`
  - KEY2 → Entradas `B[3:0]`
  - KEY3 → Entrada `SS[1:0]`
  - RESET → Entrada de reset

- **LEDs:**
  - LED0 → `c_out`
  - LED1 → `over`
  - LED2 → `SS[1]`
  - LED3 → `SS[0]`

- **Display de 7 segmentos:**
  - Apenas o **primeiro dígito (anodo[0])** é usado.
  - Lógica **invertida (nível baixo acende)**.

---

## ✅ Observações Finais

- O clock de entrada é de **50 MHz**
- A multiplexação dos displays opera a aproximadamente **500Hz**
- Se for simular, utilize o Testbench `tb_ULA.vhd` com o ModelSim ou o simulador interno do Quartus.

---
