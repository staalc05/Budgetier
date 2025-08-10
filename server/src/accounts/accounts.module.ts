import { Module } from '@nestjs/common';
import { AccountsService } from './accounts.service';
import { AccountsController } from './accounts.controller';
import { TinkService } from '../aggregator/tink.service';

/**
 * AccountsModule exposes endpoints for listing accounts and transactions. It
 * depends on the TinkService to fetch data from the external aggregator.
 */
@Module({
  controllers: [AccountsController],
  providers: [AccountsService, TinkService],
})
export class AccountsModule {}