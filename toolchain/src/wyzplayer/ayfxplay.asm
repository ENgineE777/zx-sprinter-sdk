        module ayfxSNDFLAG     equ #fde4        AYREGS      equ #fdc8AYREGS2     equ #fdc8+14;-Minimal ayFX player2 v0.16 20.06.06--------------------------;;                                                              ;; Простейший плеер эффектов. Проигрывает эффекты на одном AY,  ;; без музыки на фоне. Громкость проигрывания эффектов задаётся ;; при их вызове. Приоритет выбора каналов: если есть свободные ;; каналы, выбирается один из них. Если свободных каналов нет,  ;; выбирается наиболее давно звучащий. Процедура проигрывания   ;; использует регистры AF,BC,DE,HL,IX.                          ;;P.S. от Alone Coder'а: задействовал IY и еще 2 байта, чтобы   ;не играть эффект, когда он тише музыки         ;                                                              ;; Инициализация:                                               ;;   ld hl, адрес банка эффектов                                ;;   call AFXINIT                                               ;;                                                              ;; Запуск эффекта:                                              ;;   ld a, номер эффекта (0..255)                               ;;   ld c, относительная громкость (-15..15)                    ;;   call AFXPLAY                                               ;;                                                              ;; В обработчике прерывания:                                    ;;   call AFXFRAME                                              ;;                                                              ;;--------------------------------------------------------------;; описатели каналов, по 5+2 байт на канал:; +0 (2) текущий адрес (канал свободен, если старший байт =#00); +2 (2) время звучания эффекта; +4 (1) громкость эффекта; +6 (2) ПЕРИОД ТОНАЛЬНИКА; +7 (1) ПЕРИОД ШУМА; ...;afxChDesc       DS 3*(5+2)afxChDesc       DS 3*8;--------------------------------------------------------------;; Инициализация плеера эффектов.                               ;; Выключает все каналы, устанавливает переменные.              ;; Вход: HL = адрес банка с эффектами                           ;;--------------------------------------------------------------;                    INIT        ld a,(hl)        ld (afxEffectsAll),a        INC HL        LD (afxBnkAdr+1),HL    ;сохраняем адрес таблицы смещений        LD HL,afxChDesc         ;помечаем все каналы как пустые        LD DE,#00FF        LD B,3afxInit0        LD (HL),D        INC HL        LD (HL),D        INC HL        LD (HL),E        INC HL        LD (HL),E        INC HL        LD (HL),D        INC HL        LD (HL),D        INC HL        LD (HL),D        INC HL        ld (hl),d        inc hl        DJNZ afxInit0        RET ;--------------------------------------------------------------;; Проигрывание текущего кадра.                                 ;; Параметров не имеет.                                         ;;--------------------------------------------------------------;    FRAME        LD BC,#03FD        LD IX,afxChDescafxFrame0        PUSH BC        LD H,(IX+1)                    ;сравнение старшего байта                                                 ;адреса на <11        ld a,h        or a        jp z,afxFrame7         ;канал не играет, пропускаем        LD L,(IX+0)        LD E,(HL)          ;берём значение информационного байта        INC HL        LD A,E        ld (ix+4),E        BIT 5,E                         ;будет изменение тона?        JR Z,afxFrame1          ;тон не изменяется        LD A,(HL)        LD (IX+5),A        INC HL        LD A,(HL)        LD (IX+6),A        INC HLafxFrame1        BIT 6,E                         ;будет изменение шума?        JR Z,afxFrame3          ;шум не изменяется        LD A,(HL)                       ;читаем значение шума        SUB #20        JR C,afxFrame2          ;меньше #20, играем дальше        inc a        LD H,A                          ;иначе конец эффекта        LD (IX+2),#FF           ;делаем время наибольшим-1        LD (IX+3),#FE        LD E,#90          ld (ix+4),e              ;выключаем тон и шум в микшере        JR afxFrame3afxFrame2        add a,#20        ld (ix+7),a        INC HLafxFrame3        POP BC               ;восстанавливаем значение цикла в B        PUSH BCafxFrame5        LD b,(IX+2)                 ;увеличиваем счётчик времени        LD c,(IX+3)        INC BCafxFrame6        LD (IX+2),b        LD (IX+3),c        LD (IX+0),L                ;сохраняем изменившийся адрес        LD (IX+1),HafxFrame7        LD BC,5+3                 ;переходим к следующему каналу        ADD IX,BC        POP BC        DEC B        JP NZ,afxFrame0;        ld a,(#4012)        ld a,(SNDFLAG)        and a        jp nz,zzz        LD IX,afxChDesc        ld b,3        ld de,0afxFrame8        push bc        ld a,(ix+1)        and a        jr z,afxFrame9        dec a        jr nz,.l1        ld (ix+1),a.l1     ld a,(ix+4)        and #0f        cp e        jr c,afxFrame9        ld e,a        ld d,bafxFrame9        ld bc,8        add ix,bc        pop bc        djnz afxFrame8           ld a,d        and a        ret z        ld b,d        ld de,-8afxFrame10          add ix,de        djnz afxFrame10           ld a,(AYREGS+9)        xor a        CP 16        JR NC,$+4        SUB 3;4        JR NC,$+3        XOR A        LD (curvolCHN),A        LD A,(IX+4)        AND #0F        CP 15        JP M,$+5        LD A,15        OR A        JP P,$+4        XOR A        CP 13 ;громкую часть эффекта не глушим        JR NC,curvONcurvolCHN=$+1        CP 0        jp C,curvOFFcurvON        ld (AYREGS+9),a        ld e,(ix+4)        bit 4,e        jr nz,afxFrame11        ld a,(ix+5)        ld (AYREGS+2),a        ld a,(ix+6)        ld (AYREGS+3),aafxFrame11        bit 7,e                    jr nz,afxFrame12        ld a,(ix+7)        ld (AYREGS+6),a        ld b,3afxFrame12        LD A,%11101101          ;маска для флагов TNafxFrame13        RRC E                           ;сдвигаем флаги и маску        RRC E        RRC E        LD D,A        ld a,(AYREGS+7)        XOR E                          ;накладываем флаги канала        AND D        XOR E        ld (AYREGS+7),acurvOFF        RET zzz         ld ix,afxChDesc+16        ld a,(ix+1)        and a        jr z,.l4        dec a        jr nz,.l1        ld (ix+1),a.l1     ld a,(ix+4)        and #f        ld (AYREGS2+9),a        ld e,(ix+4)        bit 4,e        jr nz,.l2        ld a,(ix+5)        ld (AYREGS2+2),a        ld a,(ix+6)        ld (AYREGS2+3),a.l2     bit 7,e                    jr nz,.l3        ld a,(ix+7)        ld (AYREGS2+6),a.l3     LD A,%11101101        RRC E                 RRC E        RRC E        LD D,A        ld a,(AYREGS2+7)        XOR E                 AND D        XOR E        ld (AYREGS2+7),a.l4     ld ix,afxChDesc        ld a,(ix+1)        and a        jr z,.l8        dec a        jr nz,.l5        ld (ix+1),a.l5     ld a,(ix+4)        and #f        ld (AYREGS2+8),a        ld e,(ix+4)        bit 4,e        jr nz,.l6        ld a,(ix+5)        ld (AYREGS2+0),a        ld a,(ix+6)        ld (AYREGS2+1),a.l6     bit 7,e                    jr nz,.l7        ld a,(ix+7)        ld (AYREGS2+6),a.l7     LD A,%11110110        RRC E                 RRC E        rrc e        RRC E        LD D,A        ld a,(AYREGS2+7)        XOR E                 AND D        XOR E        ld (AYREGS2+7),a.l8        ld ix,afxChDesc+8        ld a,(ix+1)        and a        jr z,.l12        dec a        jr nz,.l9        ld (ix+1),a.l9     ld a,(ix+4)        and #f        ld (AYREGS2+10),a        ld e,(ix+4)        bit 4,e        jr nz,.l10        ld a,(ix+5)        ld (AYREGS2+4),a        ld a,(ix+6)        ld (AYREGS2+5),a.l10    bit 7,e                    jr nz,.l11        ld a,(ix+7)        ld (AYREGS2+6),a.l11    LD A,%11011011        RRC E                 RRC E        LD D,A        ld a,(AYREGS2+7)        XOR E                 AND D        XOR E        ld (AYREGS2+7),a.l12    ret;--------------------------------------------------------------;; Запуск эффекта на свободном канале. При отсутствии           ;; свободных каналов выбирается наиболее давно звучащий.        ;; Вход: A = номер эффекта 0..255                               ;;       С = относительная громкость -15..15                    ;;--------------------------------------------------------------;PLAYafxEffectsAll=$+1	    cp 0	    ret nc	    push ix        PUSH BC                         ;сохраняем громкость        LD DE,0                ;в DE наибольшее время при поиске        LD H,E        LD L,A        ADD HL,HLafxBnkAdr        LD BC,0                 ;адрес таблицы смещений эффектов        ADD HL,BC        LD C,(HL)        INC HL        LD B,(HL)        ADD HL,BC                    ;адрес эффекта получен в hl        PUSH HL                ;сохраняем адрес эффекта на стеке;        LD IX,afxChDesc+7+4;        jr afxPlay2        LD HL,afxChDesc         ;поиск пустого канала        LD B,3afxPlay0        INC HL        INC HL        LD A,(HL)          ;сравниваем время канала с наибольшим        INC HL;        INC HL        CP D        JR C,afxPlay1        LD C,A        LD A,(HL)        CP E        JR C,afxPlay1        LD D,C                      ;запоминаем наибольшее время        LD E,A        PUSH HL                 ;запоминаем адрес канала +3 в IX        POP IXafxPlay1        inc hl        inc hl        INC HL        INC HL        INC HL        DJNZ afxPlay0afxPlay2        POP DE                  ;забираем адрес эффекта из стека        LD (IX-3),E                  ;заносим в описатель канала        LD (IX-2),D        LD (IX-1),B                     ;зануляем время звучания        LD (IX-0),B        POP BC                          ;забираем громкость;        LD (IX-0),C             ;и заносим её в описатель канала        pop ix        ret 		endmodule