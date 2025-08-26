# 1단계: Zola v0.19.1을 사용하여 정적 사이트 빌드
FROM ghcr.io/getzola/zola:v0.19.1 as builder

# 현재 폴더의 모든 파일을 이미지 안의 /app 폴더로 복사
COPY . /app

# 작업 디렉터리를 /app 으로 변경
WORKDIR /app

# [수정된 부분] 셸 없이 직접 실행하는 'exec' 형식으로 변경
RUN ["zola", "build"]

# 2단계: Nginx를 사용하여 정적 파일 서비스
FROM nginx:alpine

# 1단계(builder)에서 생성된 'public' 폴더의 모든 파일을 Nginx의 웹 루트 디렉터리로 복사
COPY --from=builder /app/public /usr/share/nginx/html

# 컨테이너의 80번 포트를 외부에 공개
EXPOSE 80

# 컨테이너 시작 시 Nginx 웹서버를 실행
CMD ["nginx", "-g", "daemon off;"]
