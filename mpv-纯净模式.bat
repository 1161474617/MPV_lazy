:: ˵��
@echo off
echo ==========================================================
echo == ����ģʽ�����ڼ��ݲ��Ի�������;
echo ��ǰĿ¼�������� "mpv.com" �����һ�������Path�еĴ���
echo �Խӽ�ԭʼĬ�ϲ����Ĵ�ͳ��ʽ����ԭ��MPV
echo ԭ��MPV���ڴ򿪺�Ҫ��CMD�ڽ��в���
echo �رո�CMD����Ҳ���Զ��ر�MPV

:: �����ִ�еĲ�����Ϣ
echo ==========================================================
echo == ��������
echo mpv --config=no --idle=once --force-window=yes --keep-open=yes --hidpi-window-scale=no --autofit-smaller=500x500
echo ==========================================================
echo == ����Ϊ��־
echo ==========================================================

:: ����汾��Ϣ
cd /D %~dp0
mpv.com --version

:: ִ����������
mpv.com --config=no --idle=once --force-window=yes --keep-open=yes --hidpi-window-scale=no --autofit-smaller=500x500

:: �ֶ��˳���������ı�
echo ==========================================================
echo == MPV�ѹر�
echo ==========================================================
pause