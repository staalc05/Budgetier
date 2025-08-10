import { BudgetsService } from '../src/budgets/budgets.service';

describe('BudgetsService', () => {
  let service: BudgetsService;

  beforeEach(() => {
    service = new BudgetsService();
  });

  it('reassigns from savings and updates balance', () => {
    const start = service.getSummary().savingsBalance;
    const result = service.reassignFromSavings(20);
    expect(result.savingsBalance).toBe(start - 20);
  });

  it('throws when amount exceeds savings', () => {
    expect(() => service.reassignFromSavings(1000)).toThrow();
  });
});
