import { Injectable, BadRequestException } from '@nestjs/common';
import { calculateDailyAllowance } from '../budgeting/engine';

interface BudgetCategorySummary {
  id: string;
  name: string;
  planned: number;
  spent: number;
  remaining: number;
}

/**
 * A lightweight service that contains the core business logic for budgets. In
 * a real application this service would persist data to a database and
 * coordinate with other domain services (transactions, goals, notifications).
 * For the MVP we operate entirely in-memory with mocked data and focus on
 * showcasing the budgeting engine integration.
 */
@Injectable()
export class BudgetsService {
  // Mock savings balance stored in-memory. In a production system this
  // information would be derived from a ledger table.
  private savingsBalance = 100;

  /**
   * Returns a budget summary for the specified period. The summary
   * aggregates planned and spent amounts per category and computes the daily
   * allowance using the budgeting engine. If no periodId is provided the
   * current period is assumed.
   */
  getSummary(periodId?: string) {
    // Hardcoded example categories. These would normally be retrieved from
    // persistent storage along with planned amounts and spend to date.
    const categories: BudgetCategorySummary[] = [
      { id: 'groceries', name: 'Groceries', planned: 400, spent: 150, remaining: 250 },
      { id: 'housing', name: 'Housing', planned: 900, spent: 900, remaining: 0 },
      { id: 'entertainment', name: 'Entertainment', planned: 200, spent: 50, remaining: 150 },
      { id: 'savings', name: 'Savings', planned: 0, spent: 0, remaining: this.savingsBalance },
    ];

    // Example allowance calculation. In the future this should be computed
    // based on real income, fixed costs and goals for the user/group.
    const today = new Date();
    const periodStart = new Date(today.getFullYear(), today.getMonth(), 1);
    const periodEnd = new Date(today.getFullYear(), today.getMonth() + 1, 0);
    const income = 3000;
    const fixedCosts = 900; // housing in the mock categories
    const goalsContribution = 100;
    const spentToDate = categories.reduce((sum, c) => sum + c.spent, 0);
    const savingsSlider = 0.5;
    const spentToday = 0;
    const allowance = calculateDailyAllowance({
      periodStart,
      periodEnd,
      income,
      fixedCosts,
      goalContribution: goalsContribution,
      spentToDate,
      savingsSlider,
      spentToday,
    });

    return {
      periodId: periodId || 'current',
      categories,
      savingsBalance: this.savingsBalance,
      todayAllowance: allowance.allowanceToday,
    };
  }

  /**
   * Reassigns money from savings back into the active period. The amount
   * removed from savings is redistributed evenly across the remaining days
   * using the budgeting engine. Throws an error if insufficient funds are
   * available.
   */
  reassignFromSavings(amount: number, periodId?: string) {
    if (amount <= 0) {
      throw new BadRequestException('Amount must be greater than zero');
    }
    if (amount > this.savingsBalance) {
      throw new BadRequestException('Insufficient savings to reassign');
    }
    // Reduce savings and recalculate allowance. In a real application this
    // method would also record the transaction in a ledger.
    this.savingsBalance -= amount;

    const summary = this.getSummary(periodId);
    return { ...summary, message: `${amount} reassigned from savings` };
  }
}