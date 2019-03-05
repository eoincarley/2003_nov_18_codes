pro process_rstn	

	; Code to process RSTN ascii into times and fluxes

	set_line_color
	output_path='~/Data/2003_nov_18/RSTN/'
	rstnfile = '~/Data/2003_nov_18/RSTN/18NOV03.LIS'
	pos0 = [0.15, 0.52, 0.95, 0.9]
	pos1 = [0.15, 0.12, 0.95, 0.5]

	;------------------------------;
	;
	;		Read the times
	;
	result = read_csv(rstnfile)
	data = result.field1
	times = dblarr(n_elements(data))

	stop_index = n_elements(data)-1
	print, 'Processing '+rstnfile
	for i=0, stop_index do begin
		times[i] = anytim(file2time(strmid((data)[i], 4,14)), /utim)
		progress_percent, i, 0, stop_index
	endfor	

	result = read_ascii(rstnfile, data_start=0)
	data = result.field1
	dshape = size(data)


	rstn_struct = {times:times, $
				   flux_245:transpose(data[1, *]), $
				   flux_410:transpose(data[2, *]), $
				   flux_610:transpose(data[3, *]), $
				   flux_1415:transpose(data[4, *]), $
				   flux_2695:transpose(data[5, *]), $
				   flux_4995:transpose(data[6, *]), $
				   flux_8800:transpose(data[7, *]), $
				   flux_15499:transpose(data[8, *]) }

	save, rstn_struct, filename=output_path+'RSTN_flux_time_20031118.sav'			   

END	