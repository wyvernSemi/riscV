//=============================================================
//
// Copyright (c) 2023 Simon Southwell. All rights reserved.
//
// Date: 9th July 2023
//
// This file is part of the rv32 instruction set simulator.
//
// The code is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This code is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this code. If not, see <http://www.gnu.org/licenses/>.
//
//=============================================================

// -------------------------------------------------------------
// INCLUDES
// -------------------------------------------------------------

#include <stdint.h>

// FreeRTOS kernel includes
#include <FreeRTOS.h>
#include <semphr.h>
#include <queue.h>
#include <task.h>

#include "rv32_freertos.h"

// -------------------------------------------------------------
// DEFINES
// -------------------------------------------------------------

#define DELAY_PERIOD_SEC         1000
#ifndef COSIM
# define SCALE                   1
#else
# define SCALE                   40
#endif
#define COUNT_LOOPS              20
#define DEFAULT_COUNT_START      10000
#define SLEEP_DELAY_SEC          (100 * DELAY_PERIOD_SEC)

#define TASK_STACK_SIZE          256
#define TASK_PRIORITY            1
#define TASK_NULL_HANDLE         NULL

// -------------------------------------------------------------
// TYPEDEFS
// -------------------------------------------------------------

typedef struct {
    int task_num;
    int count_init;
} task_param_t;

// -------------------------------------------------------------
// FUNCTION PROTOTYPES
// -------------------------------------------------------------

// FreeRTOS interrupt handler
void freertos_risc_v_trap_handler( void );

// -------------------------------------------------------------
// Task
// -------------------------------------------------------------

void task (void* ptr)
{
    TickType_t xLastExecutionTime;
    TickType_t xDelayPeriod = DELAY_PERIOD_SEC/SCALE;

    xLastExecutionTime = xTaskGetTickCount();

    uint32_t count  = ((task_param_t*)ptr)->count_init;

    for (int idx = 0; idx < COUNT_LOOPS; idx++)
    {
        printf_("task%d: count = %d\n", ((task_param_t*)ptr)->task_num, count);
        count--;
        vTaskDelayUntil( &xLastExecutionTime, pdMS_TO_TICKS(xDelayPeriod));
    }

    while(1)
        vTaskDelay(pdMS_TO_TICKS(SLEEP_DELAY_SEC));
}

// *************************************************************
//                          M A I N
// *************************************************************

int main( void )
{
    printf_("Entered main()\n");

    task_param_t t0_params, t1_params;

    // Initialise task paramters
    t0_params.task_num   = 0;
    t0_params.count_init = DEFAULT_COUNT_START;

    t1_params.task_num   = 1;
    t1_params.count_init = 2* DEFAULT_COUNT_START;

    // Program the FreeRTOS trap handler as the one to use from now on
    csr_write(CSR_MTVEC, (uint32_t)&freertos_risc_v_trap_handler);

    // Create task 0
    if (xTaskCreate(task, "task0", TASK_STACK_SIZE, &t0_params, TASK_PRIORITY, TASK_NULL_HANDLE) != pdPASS)
    {
        printf_("***ERROR: failed to create task 0\n");
        return 1;
    }

    // Create task 1
    if (xTaskCreate(task, "task1", TASK_STACK_SIZE, &t1_params, TASK_PRIORITY, TASK_NULL_HANDLE) != pdPASS)
    {
        printf_("***ERROR: failed to create task 1\n");
        return 1;
    }

    // Start the scheduler. Should not return from here
    vTaskStartScheduler();
}

// -------------------------------------------------------------
// Application trap handlers
// -------------------------------------------------------------

// When present, will be called at each interrupt. The kernel
// will handle the timer interrupts internally, and won't call
// this function for that event.
void freertos_risc_v_application_interrupt_handler(void )
{
    uint32_t mcause;

    // Fetch the cause value for the interrupt
    csr_read(CSR_MCAUSE, &mcause);

    // Print the cause value for debug
    printf_("*Interrupt*: mcause = %x\n", mcause);
}

// When present, will be called at each exception
void freertos_risc_v_application_exception_handler(void )
{
    uint32_t mcause;

    // Fetch the cause value for the interrupt
    csr_read(CSR_MCAUSE, &mcause);

    // Print the cause value for debug
    printf_("*Exception*: mcause = %x\n", mcause);

    while(1);
}

// -------------------------------------------------------------
// Hook functions (call backs)
// -------------------------------------------------------------


// -------------------------------------------------------------
// Called if configUSE_TICK_HOOK in FreeRTOSConfig.h is set to 1
// and a timer interrupt occurs
//
#if configUSE_TICK_HOOK != 0
void vApplicationTickHook( void )
{
    printf_("Tick (%016llx)\n", xTaskGetTickCount());
}
#endif

// -------------------------------------------------------------
// Called if configUSE_IDLE_HOOK in FreeRTOSConfig.h is set to 1
// and the idle task is activated
//
#if configUSE_IDLE_HOOK != 0
void vApplicationIdleHook( void )
{
    printf_("xTickCount = %016llx\n", xTaskGetTickCount());
}
#endif

// -------------------------------------------------------------
// Called if configUSE_MALLOC_FAILED_HOOK in FreeRTOSConfig.h
// is set to 1 and memory allocation fails
#if configUSE_MALLOC_FAILED_HOOK != 0
void vApplicationMallocFailedHook( void )
{

    printf_("FreeRTOS_FAULT: vApplicationMallocFailedHook (solution: increase 'configTOTAL_HEAP_SIZE' in FreeRTOSConfig.h)\n");
    __asm volatile( "nop" );
    __asm volatile( "ebreak" );
    while(1);
}
#endif

// -------------------------------------------------------------
// Called if configCHECK_FOR_STACK_OVERFLOW in FreeRTOSConfig.h
// is set to 1 or 2 and the stack overflows
//
#if configCHECK_FOR_STACK_OVERFLOW == 1 || configCHECK_FOR_STACK_OVERFLOW == 2
void vApplicationStackOverflowHook( TaskHandle_t pxTask, char *pcTaskName )
{
    ( void ) pcTaskName;
    ( void ) pxTask;

    // Run time stack overflow checking is performed if
    // configCHECK_FOR_STACK_OVERFLOW is defined to 1 or 2.  This hook
    // function is called if a stack overflow is detected.

    taskDISABLE_INTERRUPTS();
    printf_("FreeRTOS_FAULT: vApplicationStackOverflowHook\n");
    __asm volatile( "nop" );
    __asm volatile( "nop" );
    __asm volatile( "ebreak" );
    while(1);
}
#endif


