import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { BudgetsModule } from './budgets/budgets.module';
import { AccountsModule } from './accounts/accounts.module';

/**
 * Root module for the Budgetier backend. This module imports all feature
 * modules (currently only BudgetsModule) and global providers such as
 * configuration. As the application grows additional modules can be
 * registered here (e.g. AccountsModule, GoalsModule, AuthModule).
 */
@Module({
  imports: [
    // Load environment variables from a .env file if present. This
    // configuration module will make variables available via the ConfigService.
    ConfigModule.forRoot({ isGlobal: true }),
    BudgetsModule,
    AccountsModule,
  ],
})
export class AppModule {}