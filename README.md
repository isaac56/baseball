# baseball

- BE - [Isaac✨](https://github.com/isaac56)
- iOS - [쏭🥳](https://github.com/1song2), [쑤😉](https://github.com/lenaios)

# Ground Rule

## 스크럼

- 오전 10시 30분 시작
- 매일 팀원 컨디션 체크, 어제 한 일과 오늘 할 일 공유

## 브랜치 규칙

- team9: release 브랜치
- dev: 개발 중이지만 배포 가능한 브랜치
- dev/iOS: iOS의 메인 브랜치
- dev/BE: 백엔드의 메인 브랜치

## 커밋 메시지 규칙
- 커밋 제목은 영어로, 커밋 본문은 자유(영어 또는 한글)  
- 공통 헤더: [#이슈번호]로 커밋과 관련된 이슈번호 쓰기 (이슈와 관련 없으면 생략)
```
chore: Title: 빌드 설정이나, 코드 개발 외의 기타 설정
feat: Title: 새로운 기능개발
refactor: Title: 코드 리팩토링 (구조 변경 등)
docs: Title: 문서 관련 수정 시 작성
style: Title: 포맷팅, 빠진 세미콜론, 변수명 변경 등
test: Title: 테스트코드와 관련된 변경 사항
fix: Title: 버그 수정
```
## 개발 우선순위
1. 기본 기능 (Json을 받아서 UI 그려주고, 네트워크 요청하고 등등) (Authorization 은 임시로 넣어 놓고 사용자 구분)
2. Web socket 연결 추가 (refresh 타이밍 알려 줄 수 있도록)
3. Authorization으로 인증 및 로그인

## Database 스키마 설계
![](https://github.com/isaac56/baseball/blob/dev/BE/docs/database/Schema.png)

## API 설계
<https://documenter.getpostman.com/view/1562550/TzRRBTZ1>

## OAuth Flow Chart
![OAuth_flow](https://user-images.githubusercontent.com/56751259/117400886-7b83cb00-af3e-11eb-8ac0-6656c87c72b4.png)

## Wiki
- [Link](https://github.com/isaac56/baseball/wiki)

## OAuth 화면
<img width="300" alt="스크린샷 2021-05-07 오후 2 24 58" src="https://user-images.githubusercontent.com/75113784/117401823-382a5c00-af40-11eb-87d9-059f54028b23.png"><img width="300" alt="스크린샷 2021-05-07 오후 2 25 18" src="https://user-images.githubusercontent.com/75113784/117401818-36f92f00-af40-11eb-884e-ba81b2def54e.png"><img width="300" alt="스크린샷 2021-05-07 오후 2 25 23" src="https://user-images.githubusercontent.com/75113784/117401803-319be480-af40-11eb-840a-4419a5a31bf0.png">

## 게임 화면
<img width="300" alt="스크린샷 2021-05-15 오후 4 01 41" src="https://user-images.githubusercontent.com/75113784/118351557-ac47ae00-b597-11eb-9e7c-0bcabfd22c40.png"><img width="300" alt="스크린샷 2021-05-15 오후 4 01 45" src="https://user-images.githubusercontent.com/75113784/118351552-a356dc80-b597-11eb-8f36-f83f2def9d6a.png">

<img width="300" alt="스크린샷 2021-05-15 오후 4 02 13" src="https://user-images.githubusercontent.com/75113784/118351555-aa7dea80-b597-11eb-8441-e914801a22cd.png"><img width="300" alt="스크린샷 2021-05-15 오후 4 03 42" src="https://user-images.githubusercontent.com/75113784/118351556-abaf1780-b597-11eb-8825-0357f3b607ed.png">
