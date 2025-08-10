import { Module } from '@nestjs/common';
import { BudgetsService } from './budgets.service';
import { BudgetsController } from './budgets.controller';

/**
 * BudgetsModule bundles together the controller and service responsible for
 * exposing budget-related endpoints. Over time this module can be expanded
 * with providers for data persistence, caching and business logic.
 */
@Module({
  controllers: [BudgetsController],
  providers: [BudgetsService],
})
export class BudgetsModule {}