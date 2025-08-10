import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  // A simple global prefix so all API routes start with /api
  app.setGlobalPrefix('api');
  await app.listen(process.env.PORT || 3000);
}

bootstrap().catch((err) => {
  // eslint-disable-next-line no-console
  console.error('Error starting application', err);
});