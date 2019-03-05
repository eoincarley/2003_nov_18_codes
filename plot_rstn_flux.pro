pro setup_ps, name
  
   set_plot,'ps'
   !p.font=0
   !p.charsize=1.0
   device, filename = name, $
          /color, $
          /helvetica, $
          /inches, $
          xsize=9, $
          ysize=13, $
          /encapsulate, $
          yoffset=5, $
          bits_per_pixel = 16

end

pro plt_fmt, time, flux, position, col, freq, xrange, xtickfmt=xtickfmt, xtitle=xtitle
	
	dxlabel = 0.12

	utplot, time, flux, pos=position, color=col, xtickformat=xtickfmt, xtit=xtitle, $
		ytitle='Flux (SFU)', /xs, /ys, /normal, /noerase, xrange=xrange, $
		xticklen = 1.0, xgridstyle = 1.0, thick=4

	xyouts, position[2]-dxlabel, position[3]-0.02, freq+' MHz', /normal, color=col

end

pro plot_rstn_flux, postscript=postscript
	
	; Code to plot up single frequency light curves.

	; Set up the position coords of each time series. Single column.

	ypos = 0.98
	plot_delt = 0.1
	del_inc = 0.006
	pos0 = [0.1, ypos-plot_delt, 0.93, ypos]
	pos1 = [0.1, ypos-plot_delt*2.0, 0.93, ypos-plot_delt - del_inc]
	pos2 = [0.1, ypos-plot_delt*3.0, 0.93, ypos-plot_delt*2.0- del_inc]
	pos3 = [0.1, ypos-plot_delt*4.0, 0.93, ypos-plot_delt*3.0- del_inc]
	pos4 = [0.1, ypos-plot_delt*5.0, 0.93, ypos-plot_delt*4.0- del_inc]
	pos5 = [0.1, ypos-plot_delt*6.0, 0.93, ypos-plot_delt*5.0- del_inc]
	pos6 = [0.1, ypos-plot_delt*7.0, 0.93, ypos-plot_delt*6.0- del_inc]
	pos7 = [0.1, ypos-plot_delt*8.0, 0.93, ypos-plot_delt*7.0- del_inc]
	pos8 = [0.1, ypos-plot_delt*9.0, 0.93, ypos-plot_delt*8.0- del_inc]
	set_line_color
	output_path='/Users/eoincarley/Data/2003_nov_18/RSTN/'


	file = '~/Data/2003_nov_18/RSTN/18NOV03.LIS'
	time_base = anytim('2003-11-18T07:30:00', /utim)
	t0=anytim('2003-11-18T07:30:00', /utim)
	t1=anytim('2003-11-18T09:00:00', /utim)
	xrange=[t0,t1]
	
	result = read_ascii(file, data_start=6394)
	data = result.field1
	dshape = size(data)
	nseconds = dshape[2]
	nfreqs = dshape[1]
	times = time_base + findgen(nseconds)
	tindices = where(times ge t0 and times le t1)
	freqs = ['245', '410', '610', '1415', '2695', '4995', '8800', '15400']
	colors = [0,3,4,5,6,7,8,9]
	linestyle = [1,2,3,6,5,6,7,8,9]

	flux_245 = data[1, tindices] ; 245 MHz
	flux_410 = data[2, tindices] ; 245 MHz
	flux_610 = data[3, tindices] ; 245 MHz
	flux_1415 = data[4, tindices] ; 245 MHz
	flux_2695 = data[5, tindices] ; 245 MHz
	flux_4995 = data[6, tindices] ; 245 MHz
	flux_8800 = data[7, tindices] ; 245 MHz
	flux_15499 = data[8, tindices] ; 245 MHz


	if keyword_set(postscript) then begin	
		setup_ps, output_path+'rstn_flux_20031118.eps'
	endif else begin
		loadct, 0
		!p.background=100
		!p.color=0
		window, 0, xs=800, ys=1200
		set_line_color
	endelse	

	plt_fmt, times, flux_245, pos0, colors[0], freqs[0], xrange, xtickfmt='(A1)', xtitle=' '
	plt_fmt, times, flux_410, pos1, colors[1], freqs[1], xrange, xtickfmt='(A1)', xtitle=' '
	plt_fmt, times, flux_610, pos2, colors[2], freqs[2], xrange, xtickfmt='(A1)', xtitle=' '
	plt_fmt, times, flux_1415, pos3, colors[3], freqs[3], xrange, xtickfmt='(A1)', xtitle=' '
	plt_fmt, times, flux_2695, pos4, colors[4], freqs[4], xrange, xtickfmt='(A1)', xtitle=' '
	plt_fmt, times, flux_4995, pos5, colors[5], freqs[5], xrange, xtickfmt='(A1)', xtitle=' '
	plt_fmt, times, flux_15499, pos6, colors[6], freqs[7], xrange, xtickfmt='', xtitle='Time (UT)'


	if keyword_set(postscript) then device, /close
	set_plot,'x'


END