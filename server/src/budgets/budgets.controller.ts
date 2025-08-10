import { Body, Controller, Get, Post, Query } from '@nestjs/common';
import { BudgetsService } from './budgets.service';

/**
 * Controller responsible for handling HTTP requests related to budgets. It
 * delegates actual computations to the BudgetsService. The endpoints exposed
 * here should remain thin and focus on request/response validation and
 * formatting.
 */
@Controller('budgets')
export class BudgetsController {
  constructor(private readonly budgetsService: BudgetsService) {}

  /**
   * Returns a summary of the current budget period. Clients can optionally
   * specify a periodId to fetch a historic period. The summary includes
   * planned amounts, spent amounts and daily allowance information. For now
   * this returns mocked data until database integration is added.
   */
  @Get('summary')
  async getSummary(@Query('periodId') periodId?: string) {
    return this.budgetsService.getSummary(periodId);
  }

  /**
   * Moves money from savings back into the active period. This endpoint
   * accepts an amount to reassign and optionally a specific periodId. The
   * BudgetsService will adjust future daily allowances accordingly. If the
   * amount exceeds the current savings balance the service will throw an
   * error.
   */
  @Post('reassign')
  async reassign(@Body() body: { amount: number; periodId?: string }) {
    const { amount, periodId } = body;
    return this.budgetsService.reassignFromSavings(amount, periodId);
  }
}