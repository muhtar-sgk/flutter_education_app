import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exception.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:education_app/src/on_boarding/data/repos/on_boarding_repo_impl.dart';
import 'package:education_app/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOnBoardingLocalDataSrc extends Mock implements 
  OnBoardingLocalDataSource{}
void main() {
	late OnBoardingLocalDataSource localDataSource;
  late OnBoardingRepoImpl repoImpl;

  setUp(() {
    localDataSource = MockOnBoardingLocalDataSrc();
    repoImpl = OnBoardingRepoImpl(localDataSource);
  });

  test('should be a subclass of [OnBoardingRepo]', () {
    expect(repoImpl, isA<OnBoardingRepo>());
  });
  
  group('cacheFirstTimer', () {
    test(
      'should complete successfully when call to local source', 
      () async {
        when(() => localDataSource.cacheFirstTime()).thenAnswer(
          (_) async => Future.value(),);
        
        final result = await repoImpl.cacheFirstTime();

        expect(result, equals(const Right<dynamic, void>(null)));
        verify(() => localDataSource.cacheFirstTime());
        verifyNoMoreInteractions(localDataSource);
    });
    
    test('should return CacheFailure when call the local is unsuccessfull', () async {
      when(() => localDataSource.cacheFirstTime()).thenThrow(
        const CacheException(message: 'Insufficient storage')
      );

      final result = await repoImpl.cacheFirstTime();

      expect(result, Left<CacheFailure, dynamic>(
        CacheFailure(message: 'Insufficient storage', statusCode: 500),
      ),);
      verify(() => localDataSource.cacheFirstTime());
      verifyNoMoreInteractions(localDataSource);
    });
  });
}
